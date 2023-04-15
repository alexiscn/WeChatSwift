//
//  SightMovieRecorder.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AVFoundation
import UIKit

public enum SightMovieRecorderStatus: Int {
    case idle = 0
    case preparingToRecord
    case recording
    case finishingRecordingPart1 // waiting for inflight buffers to be appended
    case finishingRecordingPart2 // calling finish writing on the asset writer
    case finished
    case failed
}

public protocol SightMovieRecorderDelegate: class {
    func movieRecorderDidFinishPreparing(_ recorder: SightMovieRecorder)
    func movieRecorder(_ recorder: SightMovieRecorder, didFailWithError error: Error)
    func movieRecorderDidFinishRecording(_ recorder: SightMovieRecorder)
}


/// Usage
/// let recorder = SightMovieRecorder(outputURL: url, delegate: self, callbackQueue: queue)
/// recorder.addVideoTrackWidthSourceFormatDescription(_:transform:settings:)
/// recorder.addAudioTackWidthSourceFormatDescription(_:settings)
/// recorder.prepareToRecord()
/// recorder.appendVideo
/// recorder.finishRecording()
public final class SightMovieRecorder: NSObject {
    
    private var status: SightMovieRecorderStatus = .idle
    private let outputURL: URL
    
    private var assetWriter: AVAssetWriter?
    private var hasStartedSession: Bool = false
    
    private var audioInput: AVAssetWriterInput?
    private var audioFormatDescription: CMAudioFormatDescription?
    private var audioSettings: [String: Any] = [:]
    
    private var videoInput: AVAssetWriterInput?
    private var videoFormatDescription: CMVideoFormatDescription?
    private var videoSettings: [String: Any] = [:]
    private var videoTransform: CGAffineTransform = .identity
    
    private weak var delegate: SightMovieRecorderDelegate?
    private let writingQueue: DispatchQueue = DispatchQueue(label: "me.shuifeng.WeChatSwift.MovieRecorder.WritingQueue")
    private var callbackQueue: DispatchQueue?
    
    public init(outputURL: URL, delegate: SightMovieRecorderDelegate, callbackQueue: DispatchQueue) {
        self.outputURL = outputURL
        self.delegate = delegate
        self.callbackQueue = callbackQueue
        super.init()
    }
    
    public func addVideoTrackWidthSourceFormatDescription(_ formatDescription: CMVideoFormatDescription,
                                                          transform: CGAffineTransform,
                                                          settings: [String: Any]) {
        synchronized(self) {
            if status != .idle {
                fatalError("Cannot add tracks while not idle")
            }
            if videoFormatDescription != nil {
                fatalError("Cannot add more than one video track")
            }
            videoFormatDescription = formatDescription
            videoSettings = settings
            videoTransform = transform
        }
    }
    
    public func addAudioTrackWithSourceFormatDescription(_ formatDescription: CMAudioFormatDescription,
                                                         settings: [String: Any]) {
        synchronized(self) {
            if status != .idle {
                fatalError("Cannot add tracks while not idle")
            }
            if audioFormatDescription != nil {
                fatalError("Cannot add more than one audio track")
            }
            audioFormatDescription = formatDescription
            audioSettings = settings
        }
    }
    
    public func prepareToRecord() {
        synchronized(self) {
            if status != .idle {
                fatalError("Already prepared, cannot prepare again")
            }
            transitionToStatus(.preparingToRecord, error: nil)
        }
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                var error: Error? = nil
                self.removeOutputFiles()
                
                do {
                    self.assetWriter = try AVAssetWriter(outputURL: self.outputURL, fileType: .mp4)
                    try self.setupVideoInput()
                    try self.setupAudioInput()
                    
                    let success = self.assetWriter?.startWriting() ?? false
                    if !success {
                        error = self.assetWriter?.error
                    }
                } catch let ex {
                    error = ex
                }
                
                synchronized(self) {
                    if let error = error {
                        self.transitionToStatus(.failed, error: error)
                    } else {
                        self.transitionToStatus(.recording, error: nil)
                    }
                }
            }
        }
    }
    
    public func appendVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        appendSampleBuffer(sampleBuffer, ofMediaType: .video)
    }
    
    public func appendVideoPixelBuffer(_ pixelBuffer: CVPixelBuffer, withPresentationTime presentationTime: CMTime) {
        var sampleBuffer: CMSampleBuffer? = nil
        var info = CMSampleTimingInfo()
        info.duration = .invalid
        info.decodeTimeStamp = .invalid
        info.presentationTimeStamp = presentationTime
        
        let error = CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                       imageBuffer: pixelBuffer,
                                                       dataReady: true,
                                                       makeDataReadyCallback: nil,
                                                       refcon: nil,
                                                       formatDescription: videoFormatDescription!,
                                                       sampleTiming: &info,
                                                       sampleBufferOut: &sampleBuffer)
        if let buffer = sampleBuffer {
            appendSampleBuffer(buffer, ofMediaType: .video)
        } else {
            print("sample buffer create failed (\(error))")
        }
    }
    
    public func appendAudioSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        appendSampleBuffer(sampleBuffer, ofMediaType: .audio)
    }
    
    /// Asynchronous, might take several hundred milliseconds.
    /// When finished the delegate's recorderDidFinishRecording: or recorder:didFailWithError: method will be called.
    public func finishRecording() {
        synchronized(self) {
            var shouldFinishRecording = false
            switch status {
            case .idle,
                 .preparingToRecord,
                 .finishingRecordingPart1,
                 .finishingRecordingPart2,
                 .finished:
                fatalError("Not recording")
            case .failed:
                // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
                // Because of this we are lenient when finishRecording is called and we are in an error state.
                print("Recording has failed, nothing to do")
            case .recording:
                shouldFinishRecording = true
            }
            
            if shouldFinishRecording {
                self.transitionToStatus(.finishingRecordingPart1, error: nil)
            } else {
                return
            }
        }
        
        writingQueue.async {
            autoreleasepool {
                synchronized(self) {
                    // We may have transitioned to an error state as we appended inflight buffers. In that case there is nothing to do now.
                    if self.status != .finishingRecordingPart1 {
                        return
                    }
                    
                    // It is not safe to call -[AVAssetWriter finishWriting*] concurrently with -[AVAssetWriterInput appendSampleBuffer:]
                    // We transition to MovieRecorderStatusFinishingRecordingPart2 while on _writingQueue, which guarantees that no more buffers will be appended.
                    self.transitionToStatus(.finishingRecordingPart2, error: nil)
                }
                
                self.assetWriter?.finishWriting {
                    synchronized(self) {
                        if let error = self.assetWriter?.error {
                            self.transitionToStatus(.failed, error: error)
                        } else {
                            self.transitionToStatus(.finished, error: nil)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Private Work
extension SightMovieRecorder {
    
    private func appendSampleBuffer(_ sampleBuffer: CMSampleBuffer, ofMediaType mediaType: AVMediaType) {
        synchronized(self) {
            if status.rawValue < SightMovieRecorderStatus.recording.rawValue {
                fatalError("Not ready to record yet")
            }
        }
        writingQueue.async {
            autoreleasepool {
                synchronized(self) {
                    // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
                    // Because of this we are lenient when samples are appended and we are no longer recording.
                    // Instead of throwing an exception we just release the sample buffers and return.
                    if self.status.rawValue > SightMovieRecorderStatus.finishingRecordingPart1.rawValue {
                        return
                    }
                }
                
                if !self.hasStartedSession {
                    self.assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                    self.hasStartedSession = true
                }
                
                let input = mediaType == .video ? self.videoInput: self.audioInput
                let readyForMediaData = input?.isReadyForMoreMediaData ?? false
                if readyForMediaData {
                    let success = input?.append(sampleBuffer) ?? false
                    if !success {
                        let error = self.assetWriter?.error
                        synchronized(self) {
                            self.transitionToStatus(.failed, error: error)
                        }
                    }
                } else {
                    print(":\(mediaType) input not ready for more media data, dropping buffer")
                }
            }
        }
    }
    
    private func setupVideoInput() throws {
        
        if videoSettings.isEmpty {
            videoSettings = [
                AVVideoCodecKey: AVVideoCodecType.h264
            ]
        }
        
        let canApply = assetWriter?.canApply(outputSettings: videoSettings, forMediaType: .video) ?? false
        if canApply {
            let input = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings, sourceFormatHint: videoFormatDescription)
            input.expectsMediaDataInRealTime = true
            
            let canAdd = assetWriter?.canAdd(input) ?? false
            if canAdd {
                assetWriter?.add(input)
                videoInput = input
            }
        }
    }
    
    private func setupAudioInput() throws {
        if audioSettings.isEmpty {
            audioSettings = [AVFormatIDKey : UInt(kAudioFormatMPEG4AAC)]
        }
        let canApply = assetWriter?.canApply(outputSettings: audioSettings, forMediaType: .audio) ?? false
        if canApply {
            let input = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings, sourceFormatHint: audioFormatDescription)
            input.expectsMediaDataInRealTime = true
            
            let canAdd = assetWriter?.canAdd(input) ?? false
            if canAdd {
                assetWriter?.add(input)
                audioInput = input
            }
        }
    }
    
    private func transitionToStatus(_ newStatus: SightMovieRecorderStatus, error: Error?) {
        var shouldNotifyDelegate = false
        
        if newStatus != status {
            if newStatus == .finished || newStatus == .failed {
                shouldNotifyDelegate = true
                writingQueue.async {
                    self.teardownWriterAndInputs()
                    if newStatus == .failed {
                        self.removeOutputFiles()
                    }
                }
            } else if newStatus == .recording {
                shouldNotifyDelegate = true
            }
            status = newStatus
        }
        
        if shouldNotifyDelegate {
            callbackQueue?.async {
                autoreleasepool {
                    switch self.status {
                    case .recording:
                        self.delegate?.movieRecorderDidFinishPreparing(self)
                    case .finished:
                        self.delegate?.movieRecorderDidFinishRecording(self)
                    case .failed:
                        self.delegate?.movieRecorder(self, didFailWithError: error!)
                    default:
                        fatalError("Unexpected recording status (\(newStatus)) for delegate callback")
                    }
                }
            }
        }
    }
    
    private func removeOutputFiles() {
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch {
            print(error)
        }
    }
    
    private func teardownWriterAndInputs() {
        assetWriter = nil
        videoInput = nil
        audioInput = nil
    }
}
