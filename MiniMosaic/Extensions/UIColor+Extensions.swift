//
//  UIColor+Extensions.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 07.09.2024.
//

import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
