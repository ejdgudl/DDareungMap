//
//  LaunchView.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/19.
//

import UIKit

class LaunchView: UIView {
    
    private let launchView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.zPosition = 999999999999999999
        let label1 = UILabel()
        label1.textColor = .white
        label1.font = .systemFont(ofSize: 20, weight: .semibold)
        label1.getLauchAttributedString(lhs: "Data 불러오는중", rhs: "\n 다소 시간이 소요될 수 있습니다.")
        label1.numberOfLines = 0
        label1.textAlignment = .center
        view.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_opentype01")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(15)
            make.width.equalTo(50)
        }
        let label3 = UILabel()
        label3.textColor = .white
        label3.font = .systemFont(ofSize: 7, weight: .light)
        label3.numberOfLines = 0
        label3.text = "데이터 제공부서 \n 서울특별시 도시교통실 \n보행친화기획관 자전거정책과 \n 담당자 \n 김석수"
        label3.textAlignment = .center
        view.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        let label4 = UILabel()
        label4.textColor = .white
        label4.font = .systemFont(ofSize: 8, weight: .regular)
        label4.text = "본 저작물은 '서울특별시'에서 '20년'작성하여 \n공공누리 제1유형으로 개방한 '저작물명(작성자:김석수)'을 이용하였으며,\n해당 저작물은 '서울자전거 홈페이지'에서 무료로 다운받으실 수 있습니다."
        label4.textAlignment = .center
        label4.numberOfLines = 0
        view.addSubview(label4)
        label4.snp.makeConstraints { (make) in
            make.bottom.equalTo(label3.snp.top).inset(-17)
            make.centerX.equalToSuperview()
        }
        let label2 = UILabel()
        label2.textColor = .white
        label2.font = .systemFont(ofSize: 7, weight: .regular)
        label2.text = "ver 1.0"
        label2.textAlignment = .center
        view.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.top.equalTo(label3.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(launchView)
        launchView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
