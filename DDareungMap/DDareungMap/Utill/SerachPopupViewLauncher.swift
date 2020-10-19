//
//  SerachPopupViewLauncher.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/19.
//

import UIKit
import MapKit
import CoreLocation

protocol SearchPopupViewDelegate: class {
    func PopupViewDelegate()
}

class SearchPopupViewLauncher: NSObject {
    
    // MARK: - Properties
    var subStationInfos = [SubStationInfo]() {
        didSet {
            print(subStationInfos)
        }
    }
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .white
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
    
    private var window: UIWindow?
    weak var delegate: SearchPopupViewDelegate?
    
    // MARK: - Selector
    @objc private func didTapBackView() {
        delegate?.PopupViewDelegate()
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
    
    // MARK: - Configure
    private func configure() {
        
    }
    
    
    // MARK: - ConfigureViews
    private func configureViews() {
        
//        [].forEach {
//            .addSubview($0)
//        }

        
    }
    
}
