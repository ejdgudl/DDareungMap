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
    func goToSelectSubway(stationCoordinate: CLLocationCoordinate2D)
}

class SearchPopupViewLauncher: NSObject {
    
    // MARK: - Properties
    var subStationInfos = [SubStationInfo]() {
        didSet {
            print(subStationInfos)
        }
    }
    
    var searchResults = [SubStationInfo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.showsCancelButton = true
        bar.placeholder = "역 이름을 입력해주세요"
        return bar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 40
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private var window: UIWindow?
    weak var delegate: SearchPopupViewDelegate?
    
    // MARK: - Init
    override init() {
        super.init()
        configure()
    }
    
    // MARK: - Selector
    @objc private func didTapBackView() {
        delegate?.PopupViewDelegate()
        searchBar.endEditing(true)
        
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellID)
    }
    
    
    // MARK: - ConfigureViews
    private func configureViews() {
        
        [searchBar, tableView].forEach {
            mainView.addSubview($0)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}

extension SearchPopupViewLauncher: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellID, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        
            cell.subStation = searchResults[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            self.backView.alpha = 0
            self.mainView.frame.origin.y += 450
        }
        
        let subStationName = searchResults[indexPath.row].stationName
        
        let addres = subStationName + "역"
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addres) { (placeMark, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let place = placeMark?.first else { return }
            guard let coordinate = place.location?.coordinate else { return }
            self.delegate?.goToSelectSubway(stationCoordinate: coordinate)
        }
        
    }
    
}
