//
//  BaseMiniAppView.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 05.09.2024.
//

import UIKit

protocol MiniAppViewProtocol {
    func setupView()
    func configure(with data: Any)
}

class BaseMiniAppView: UIView, MiniAppViewProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.randomColor()
    }
    
    func configure(with data: Any) {}
}
