//
//  ViewController.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Properties
    private var stationInfos = [StationInfo]() {
        didSet {
            configureStationInfos()
        }
    }
    
    private let mapView = MKMapView()
    private let locationManger = CLLocationManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        configure()
        configureNavi()
        configureViews()
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    
    // MARK: - Helpers
    private func getData() {
        Service.shared.getData { (stationInfos) in
            self.stationInfos = stationInfos
        }
    }
    // MARK: - Configure Station Infos
    private func configureStationInfos() {
        
        stationInfos.forEach {
            
            guard let coordinate = $0.coordinate else {
                return
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            annotation.title = $0.stationName
            annotation.subtitle = $0.parkingCount
            mapView.addAnnotations([annotation])
        }
        
    }
    
    // MARK: - Configure
    private func configure() {
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.distanceFilter = kCLDistanceFilterNone
        locationManger.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    // MARK: - ConfigureNavi
    private func configureNavi() {
        
    }
    
    // MARK: - ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        [mapView].forEach {
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }


}

