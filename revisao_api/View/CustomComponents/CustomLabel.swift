//
//  CustomLabel.swift
//  revisao_api
//
//  Created by Victor Pizetta on 02/05/23.
//

import UIKit

class CustomLabel: UILabel {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    func configureLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 17)
        layer.masksToBounds = true
        layer.cornerRadius = 8
        numberOfLines = 0
        textColor = .black
        textAlignment = .left
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
