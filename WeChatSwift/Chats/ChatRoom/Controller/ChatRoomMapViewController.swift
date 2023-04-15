//
//  ChatRoomMapViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import MapKit
import WXActionSheet

class ChatRoomMapViewController: UIViewController {
    
    private var backButton: UIButton!
    private var moreButton: UIButton!
    private var myLocationButton: UIButton!
    private var mapView: MKMapView!
    private var informationView: UIView!
    
    private let location: LocationMessage
    
    init(location: LocationMessage) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        
        let backButton = UIButton(type: .custom)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 16)
        backButton.setImage(UIImage(named: "barbuttonicon_back_cube_30x30_"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let moreButton = UIButton(type: .custom)
        moreButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 0)
        moreButton.setImage(UIImage(named: "barbuttonicon_more_cube_30x30_"), for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
        
        setupInformationView()
        setupMyLocationButton()
        fixNavigationSwipeGesture()
    }
    
    private func setupMyLocationButton() {
        myLocationButton = UIButton(type: .custom)
        myLocationButton.setImage(UIImage(named: "location_my_50x50_"), for: .normal)
        myLocationButton.setImage(UIImage(named: "location_my_HL_50x50_"), for: .normal)
        myLocationButton.setImage(UIImage(named: "location_my_current_50x50_"), for: .selected)
        view.addSubview(myLocationButton)
    }
    
    private func setupMapView() {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100))
        mapView.mapType = .mutedStandard
        mapView.centerCoordinate = location.coordinate
        mapView.showsCompass = false
        mapView.showsBuildings = true
        view.addSubview(mapView)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func setupInformationView() {
        let height = Constants.bottomInset + 90.0
        
        informationView = UIView()
        informationView.backgroundColor = Colors.white
        view.addSubview(informationView)
        informationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            informationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            informationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            informationView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        let locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 21)
        locationLabel.textColor = Colors.black
        locationLabel.text = location.title
        informationView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 15),
            locationLabel.centerYAnchor.constraint(equalTo: informationView.centerYAnchor, constant: -10),
            locationLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -70)
        ])
        
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        addressLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        addressLabel.text = location.subTitle
        informationView.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 15),
            addressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 3),
            addressLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -70)
        ])
        
        let directionButton = UIButton(type: .custom)
        directionButton.setImage(UIImage(named: "locationSharing_navigate_icon_new_50x50_"), for: .normal)
        directionButton.setImage(UIImage(named: "locationSharing_navigate_icon_HL_new_50x50_"), for: .highlighted)
        informationView.addSubview(directionButton)
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            directionButton.widthAnchor.constraint(equalToConstant: 50),
            directionButton.heightAnchor.constraint(equalToConstant: 50),
            directionButton.centerYAnchor.constraint(equalTo: informationView.centerYAnchor),
            directionButton.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -16)
        ])
    }
    
    private func fixNavigationSwipeGesture() {
        let transparent = UIView()
        transparent.backgroundColor = .clear
        transparent.frame = CGRect(x: 0, y: 0, width: 16, height: view.bounds.height)
        view.addSubview(transparent)
    }
    
    override var wx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
}

// MARK: - Event Handlers
extension ChatRoomMapViewController {
    
    @objc private func directionButtonClicked() {
        
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moreButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "发送给朋友", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "收藏", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    @objc private func myLocationButtonClicked() {
        
    }
    
}
