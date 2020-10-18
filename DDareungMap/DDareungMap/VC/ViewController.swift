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
            self.setRegion(setCase: .goToCurrentLocation)
        })
        return button
    }()
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var setRegionCase: SetRegionCase!
    private let popupViewLauncher = PopupViewLauncher()
    
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
        setRegion(setCase: .test)
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
    
    private func setRegion(setCase: SetRegionCase, completion: (() -> ())? = nil) {
        
        var region: MKCoordinateRegion!
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        switch setCase {
        
        case .test:
            // 서울역 (Develop Step)
            let testCoordinate = CLLocationCoordinate2D(latitude: 37.553697, longitude: 126.969718)
            region = MKCoordinateRegion(center: testCoordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
            
        case .viewDidAppear:
            region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
            
        case .goToCurrentLocation:
            region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
            
        case .didSelect(let coordinate):
            region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        }
        
        mapView.setRegion(region, animated: true)
        completion?()
    }
    
    // MARK: - Configure Station Infos
    private func configureStationInfos() {
        
        stationInfos.forEach {
            
            guard let coordinate = $0.coordinate else {
                return
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
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
        mapView.delegate = self
        popupViewLauncher.delegate = self
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

extension ViewController: MKMapViewDelegate {
    
    // MARK: - view for annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var bikeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annoView") as? MKMarkerAnnotationView
        
        if bikeAnnotationView == nil {
            bikeAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annoView")
        } else {
            bikeAnnotationView?.annotation = annotation
        }
        
        stationInfos.forEach {
            
            if $0.stationName == annotation.title {
                bikeAnnotationView?.glyphText = annotation.subtitle!
                
                if ["0", "1", "2", "3", "4", "5"].contains($0.parkingCount) {
                    bikeAnnotationView?.markerTintColor = .systemRed
                } else if ["6", "7", "8", "9", "10"].contains($0.parkingCount) {
                    bikeAnnotationView?.markerTintColor = .systemOrange
                } else if ["11", "12", "13", "14", "15"].contains($0.parkingCount) {
                    bikeAnnotationView?.markerTintColor = .systemGreen
                } else {
                    bikeAnnotationView?.markerTintColor = .systemBlue
                }
                
                bikeAnnotationView?.canShowCallout = true
            }
        }
        
        bikeAnnotationView?.canShowCallout = true
        
        return bikeAnnotationView
    }
    
    // MARK: - did select
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        setRegionCase = .didSelect(view.annotation!.coordinate)
        
        self.popupViewLauncher.show()
        self.popupViewLauncher.annotationView = view
        
        UIView.animate(withDuration: 0.5) {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 190
            }
            self.setRegion(setCase: self.setRegionCase)
        }
        
    }
}

extension ViewController: PopupViewDelegate {
    
    func PopupViewDelegate(annotationView: MKAnnotationView) {
        
        UIView.animate(withDuration: 0.5) {
            
            annotationView.isSelected = false
            
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 190
            }
        }
    }
    
}
