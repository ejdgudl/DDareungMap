//
//  PopupViewLauncher.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import UIKit
import MapKit

protocol PopupViewDelegate: class {
    func PopupViewDelegate(annotationView: MKAnnotationView)
}

class PopupViewLauncher: NSObject {
    
    // MARK: - Properties
    private let mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .red
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
    weak var delegate: PopupViewDelegate?
    var annotationView: MKAnnotationView?
    
    // MARK: - Selector
    @objc private func didTapBackView() {
        
        delegate?.PopupViewDelegate(annotationView: self.annotationView!)
        
        UIView.animate(withDuration: 0.5) {
            self.backView.alpha = 0
            self.mainView.frame.origin.y += 400
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
                                width: window.frame.width, height: 400)
        
        UIView.animate(withDuration: 0.5) {
            self.backView.alpha = 0.1
            self.mainView.frame.origin.y -= 400
        }
        
        
    }
    
    // MARK: - Configure
    private func configure() {
        
    }
    
    
    // MARK: - ConfigureViews
    private func configureViews() {
        
    }
    
}
