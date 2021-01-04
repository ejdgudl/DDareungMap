//
//  SearchResultCell.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/20.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    // MARK: - Properties
    static let cellID = "SearchResultCell"
    
    private let lineNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let stationNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let deviderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var subStation: SubStationInfo? {
        didSet {
            stationNameLabel.text = subStation?.stationName
            lineNameLabel.text = subStation?.lineNum
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    
    // MARK: - Helpers
    
    
    // MARK: - Configure
    private func configure() {
        selectionStyle = .none
    }

    // MARK: - ConfigureViews
    private func configureViews() {
        backgroundColor = .systemBackground
        
        [lineNameLabel, stationNameLabel, deviderView].forEach {
            addSubview($0)
        }
        
        lineNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }
        
        stationNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(lineNameLabel.snp.right).offset(50)
        }
        
        deviderView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}
