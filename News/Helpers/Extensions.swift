//
//  Extensions.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import UIKit

extension UIColor {
    class var random: UIColor{
        return UIColor(red:   .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue:  .random(in: 0...1),
                       alpha: 1.0)
    }
}
