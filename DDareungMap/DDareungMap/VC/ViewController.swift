//
//  ViewController.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/18.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    private var stationInfos = [StationInfo]() {
        didSet {
            stationInfos.forEach {
                print($0.stationName)
            }
        }
    }
    
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
    
    // MARK: - Configure
    private func configure() {
        
    }
    
    // MARK: - ConfigureNavi
    private func configureNavi() {
        
    }
    
    // MARK: - ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
    }


}

