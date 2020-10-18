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
import Floaty

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Properties
    private var stationInfos = [StationInfo]() {
        didSet {
            configureStationInfos()
        }
    }
    
    private lazy var floatButton: Floaty = {
        let button = Floaty()
        button.addItem(title: "현재 내 위치", handler: { item in
            self.setregion()
        })
        return button
    }()
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        configure()
        configureNavi()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setregion()
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
    
    private func setregion() {
        
//        guard let coordinate = locationManager.location?.coordinate else {
//            return
//        }
        
        // test
        let testCoordinate =  CLLocationCoordinate2D(latitude: 37.553697, longitude: 126.969718)
        
        let region = MKCoordinateRegion(center: testCoordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
        
        mapView.setRegion(region, animated: true)
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    // MARK: - ConfigureNavi
    private func configureNavi() {
        
    }
    
    // MARK: - ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        [mapView, floatButton].forEach {
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }


}

