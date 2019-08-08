//
//  UIView+Rounded.swift
//  Currency Converter
//
//  Created by Henry Chukwu on 8/7/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit

extension UIView {
    func rounded() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.8
    }

    func roundedCorner() {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}
