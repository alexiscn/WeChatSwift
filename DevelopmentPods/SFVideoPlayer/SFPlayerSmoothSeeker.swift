//
//  SFPlayerSmoothSeeker.swift
//  SFVideoPlayer
//
//  Created by alexiscn on 2019/9/10.
//

import AVFoundation

/// https://developer.apple.com/library/archive/qa/qa1820/_index.html
public class SFPlayerSmoothSeeker {
    
    private var isSeekInProgress = false
    private let player: AVPlayer
    private var chaseTime = CMTime.zero
    
    public init(player: AVPlayer) {
        self.player = player
    }
    
    public func stopPlayingAndSeekSmoothlyToTime(_ newChaseTime: CMTime) {
        player.pause()
        if CMTimeCompare(newChaseTime, chaseTime) != 0 {
            chaseTime = newChaseTime
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    public func cancelSeeking() {
        isSeekInProgress = false
        chaseTime = .invalid
    }
    
    private func trySeekToChaseTime() {
        if player.status == .unknown {
            
        } else if player.status == .readyToPlay {
            
        }
    }
    
    private func actuallySeekToTime() {
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        player.seek(to: seekTimeInProgress, toleranceBefore: .zero, toleranceAfter: .zero) { (finished) in
            if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.isSeekInProgress = false
            } else {
                self.trySeekToChaseTime()
            }
        }
    }
}
