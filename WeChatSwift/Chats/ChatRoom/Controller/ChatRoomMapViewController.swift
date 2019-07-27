//
//  ChatRoomMapViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/27.
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
        setupBackButton()
        setupMoreButton()
        setupInformationView()
        setupMyLocationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupBackButton() {
        backButton = UIButton(type: .custom)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        backButton.setImage(UIImage(named: "barbuttonicon_back_cube_30x30_"), for: .normal)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.statusBarHeight)
            make.height.equalTo(44)
            make.width.equalTo(62)
        }
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    private func setupMoreButton() {
        moreButton = UIButton(type: .custom)
        moreButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        moreButton.setImage(UIImage(named: "barbuttonicon_more_cube_30x30_"), for: .normal)
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.statusBarHeight)
            make.height.equalTo(44)
            make.width.equalTo(62)
        }
        moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
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
        informationView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
        
        let locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 21)
        locationLabel.textColor = Colors.black
        locationLabel.text = location.title
        informationView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-70)
        }
        
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        addressLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        addressLabel.text = location.subTitle
        informationView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(locationLabel.snp.bottom).offset(3)
            make.trailing.equalToSuperview().offset(-70)
        }
        
        let directionButton = UIButton(type: .custom)
        directionButton.setImage(UIImage(named: "locationSharing_navigate_icon_new_50x50_"), for: .normal)
        directionButton.setImage(UIImage(named: "locationSharing_navigate_icon_HL_new_50x50_"), for: .highlighted)
        informationView.addSubview(directionButton)
        directionButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}

// Event Handlers
extension ChatRoomMapViewController {
    
    @objc private func directionButtonClicked() {
        
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moreButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
        actionSheet.add(WXActionSheetItem(title: "发送给朋友", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "收藏", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    @objc private func myLocationButtonClicked() {
        
    }
    
}
