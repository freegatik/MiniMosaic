//
//  MiniAppCollectionViewCell.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 05.09.2024.
//

import UIKit

class MiniAppCollectionViewCell: UICollectionViewCell {
    
    var miniAppView: BaseMiniAppView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }
    
    func configure(with miniApp: BaseMiniAppView) {
        miniAppView = miniApp
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(miniApp)
        miniApp.frame = contentView.bounds
        miniApp.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

private extension MiniAppCollectionViewCell {
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        if isUserInteractionEnabled {
            miniAppView?.backgroundColor = UIColor.randomColor()
        }
    }
}
