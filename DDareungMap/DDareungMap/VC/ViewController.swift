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
import Loaf

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    var bikeStationInfos = [StationInfo]() {
        didSet {
            configureStationInfos()
        }
    }
    
    var subStationInfos = [SubStationInfo]()

    private lazy var floatButton: Floaty = {
        let button = Floaty()
        button.alpha = 0
        button.buttonColor = .systemGreen
        button.addItem("현재 내 위치", icon: UIImage(systemName: "location")) { (item) in
            self.setRegion(setCase: .goToCurrentLocation)
        }
        button.addItem("역으로 이동하기", icon: UIImage(systemName: "mappin")) { (item) in
            self.searchPopupViewLauncher.subStationInfos = self.subStationInfos
            self.searchPopupViewLauncher.show()
        }
        button.addItem("문의", icon: UIImage(systemName: "doc.plaintext")) { (item) in
            let alert = UIAlertController(title: "문의", message: "ejdgudl@gmail.com", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        return button
    }()
    
    private let launchView = LaunchView()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var setRegionCase: SetRegionCase!
    private let infoPopupViewLauncher = InfoPopupViewLauncher()
    private let searchPopupViewLauncher = SearchPopupViewLauncher()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setRegion(setCase: .test) {
            Loaf("  잠시만 기다려 주세요 ~ 🚴‍♀️🚴‍♂️🚴‍♀️", state: .info, location: .top, sender: self).show()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.launchView.alpha = 0
            self.floatButton.alpha = 1
            self.launchView.removeFromSuperview()
        })
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
    
    private func setRegion(setCase: SetRegionCase, completion: (() -> ())? = nil) {
        
        var region: MKCoordinateRegion!
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        switch setCase {
        
        case .test:
            // 서울역 (Develop Step)
            let testCoordinate = CLLocationCoordinate2D(latitude: 37.553697, longitude: 126.969718)
            region = MKCoordinateRegion(center: testCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
        case .viewDidAppear:
            region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
        case .goToCurrentLocation:
            region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
        case .didSelect(let coordinate):
            region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            
        case .didDeSelect(let coordinate):
            region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
        
        mapView.setRegion(region, animated: true)
        completion?()
    }
    
    // MARK: - Configure Station Infos
    private func configureStationInfos() {
        
        bikeStationInfos.forEach {
            
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
        mapView.isZoomEnabled = false
        infoPopupViewLauncher.delegate = self
        infoPopupViewLauncher.locationManager = self.locationManager
        searchPopupViewLauncher.delegate = self
        searchPopupViewLauncher.searchBar.delegate = self
    }
    
    // MARK: - ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        [mapView, floatButton, launchView].forEach {
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
            
        mapView.addSubview(launchView)
        
        launchView.snp.makeConstraints { (make) in
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
            bikeAnnotationView = NonClusteringMKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annoView")
        } else {
            bikeAnnotationView?.annotation = annotation
        }
        
        bikeStationInfos.forEach {
            
            if $0.stationName == annotation.title {
                bikeAnnotationView?.glyphText = annotation.subtitle!
                
                if ["0"].contains($0.parkingCount) {
                    bikeAnnotationView?.markerTintColor = .black
                    bikeAnnotationView?.glyphText = "🙅🏻"
                } else if ["1", "2", "3", "4", "5"].contains($0.parkingCount) {
                    bikeAnnotationView?.markerTintColor = .systemRed
                } else if ["6", "7", "8", "9", "10"].contains($0.parkingCount) {
                    bikeAnnotationView?.markerTintColor = .systemOrange
                } else if ["11", "12", "13", "14", "15"].contains($0.parkingCount) {
                    bikeAnnotationView?.markerTintColor = .systemGreen
                } else {
                    bikeAnnotationView?.markerTintColor = .systemBlue
                }
            }
        }
        
        return bikeAnnotationView
    }
    
    // MARK: - did select
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.infoPopupViewLauncher.annotationView = view
        self.infoPopupViewLauncher.stationInfos = self.bikeStationInfos
        
        setRegionCase = .didSelect(view.annotation!.coordinate)
        
        self.infoPopupViewLauncher.show()
        
        UIView.animate(withDuration: 0.5) {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 190
            }
            self.setRegion(setCase: self.setRegionCase)
        }
        
    }
}

extension ViewController: InfoPopupViewDelegate {
    
    func PopupViewDelegate(annotationView: MKAnnotationView) {
        
        UIView.animate(withDuration: 0.5) {
            self.setRegion(setCase: .didDeSelect(annotationView.annotation!.coordinate))
            annotationView.isSelected = false
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 190
            }
        }
    }
    
}

extension ViewController: SearchPopupViewDelegate {
    
    func goToSelectSubway(stationCoordinate: CLLocationCoordinate2D) {
        setRegion(setCase: .didDeSelect(stationCoordinate))
        searchPopupViewLauncher.searchBar.text = ""
        searchPopupViewLauncher.searchResults.removeAll()
    }
    
    func PopupViewDelegate() {
        searchPopupViewLauncher.searchBar.text = ""
        searchPopupViewLauncher.searchResults.removeAll()
        print("해당 역으로 이동")
    }
    
}

// MARK: - UISearchBar Delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchPopupViewLauncher.searchResults.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let text = searchBar.text else { return }
        
        subStationInfos.forEach {
            if text.contains($0.stationName) {
                searchPopupViewLauncher.searchResults.append($0)
            }
        }
    }
    
}
