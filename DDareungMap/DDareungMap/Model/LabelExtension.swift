//
//  LabelExtension.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/19.
//

import UIKit

extension UILabel {
    
    func getAttributedString(lhs: String, rhs: String) {
        let attributedTitle = NSMutableAttributedString(string: lhs, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: rhs, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedText = attributedTitle

    }
    
}
