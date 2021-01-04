//
//  PopupViewLauncher.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import UIKit
import MapKit
import CoreLocation

protocol InfoPopupViewDelegate: class {
    func PopupViewDelegate(annotationView: MKAnnotationView)
}

class InfoPopupViewLauncher: NSObject {
    
    // MARK: - Properties
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .systemBackground
        return mainView
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackView))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private let stationNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let stationIDLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let snapShotView = UIView(frame: .zero)
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let dockCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let parkingCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dockCountLabel, parkingCountLabel, distanceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private var window: UIWindow?
    weak var delegate: InfoPopupViewDelegate?
    var annotationView: MKAnnotationView?
    var stationInfos = [StationInfo]()
    var locationManager: CLLocationManager?
    
    // MARK: - Selector
    @objc private func didTapBackView() {
        
        delegate?.PopupViewDelegate(annotationView: self.annotationView!)
        
        UIView.animate(withDuration: 0.5) {
            self.backView.alpha = 0
            self.mainView.frame.origin.y += 450
        }
    }
    
    // MARK: - Helpers
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
        self.window = window
        
        window.addSubview(backView)
        backView.frame = window.frame
        
        window.addSubview(mainView)
        mainView.frame = CGRect(x: 0, y: window.frame.height,
                                width: window.frame.width, height: 450)
        
        configureViews()
        
        UIView.animate(withDuration: 0.5) {
            self.backView.alpha = 0.1
            self.mainView.frame.origin.y -= 450
        }
    }
    
    private func configureSnapshot(annotationView: MKAnnotationView?) {
        
        // MARK: - SnapShot
        let snapShotSize = CGSize(width: 200, height: 200)
        
        snapShotView.translatesAutoresizingMaskIntoConstraints = false
        snapShotView.widthAnchor.constraint(equalToConstant: snapShotSize.width).isActive = true
        snapShotView.heightAnchor.constraint(equalToConstant: snapShotSize.height).isActive = true
        
        let options = MKMapSnapshotter.Options()
        options.size = snapShotSize
        options.mapType = .standard
        options.camera = MKMapCamera(lookingAtCenter: (annotationView?.annotation?.coordinate)!, fromDistance: 100, pitch: 0, heading: 0)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: snapShotSize.width, height: snapShotSize.height))
                imageView.image = snapshot.image
                self.snapShotView.addSubview(imageView)
            }
            
        }
        mainView.addSubview(snapShotView)
        snapShotView.snp.makeConstraints { (make) in
            make.top.equalTo(stationIDLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    private func configure() {
        
    }
    
    
    // MARK: - ConfigureViews
    private func configureViews() {
        
        [stationNameLabel, stationIDLabel, stackView].forEach {
            mainView.addSubview($0)
        }
        
        stationNameLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(12)
        }
        
        stationIDLabel.snp.makeConstraints { (make) in
            make.top.equalTo(stationNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        configureSnapshot(annotationView: annotationView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(snapShotView.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(50)
            
        }
        
        if let title = self.annotationView?.annotation?.title! {
            stationInfos.forEach {
                if title == $0.stationName {

                    stationNameLabel.text = $0.stationName
                    stationIDLabel.text = $0.stationID
                    
                    dockCountLabel.getAttributedString(lhs: "대여소의 총 거치대 개수:   ", rhs: $0.dockCount)
                    
                    parkingCountLabel.getAttributedString(lhs: "대여소의 남은 자전거 개수:   ", rhs: $0.parkingCount)
                    
                    let distanceFormatter = MKDistanceFormatter()
                    distanceFormatter.unitStyle = .abbreviated
                    
                    guard let userLocation = locationManager?.location else { return }
                    let destination = $0.location
                    let distance = userLocation.distance(from: destination!)
                    let distanceAsString = distanceFormatter.string(fromDistance: distance)
                    distanceLabel.getAttributedString(lhs: "대여소까지: ", rhs: distanceAsString)
                }
            }
        }
        
    }
    
}
