//
//  UIView+Constraints.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit

extension UIView {

    func setAnchorsWithoutConstants(topAnchor: NSLayoutYAxisAnchor? = nil, leadingAnchor: NSLayoutXAxisAnchor? = nil, trailingAnchor: NSLayoutXAxisAnchor? = nil, bottomAnchor: NSLayoutYAxisAnchor? = nil, widthDimension: NSLayoutDimension? = nil, heightDimension: NSLayoutDimension? = nil, centerXAnchor: NSLayoutXAxisAnchor? = nil, centerYAnchor: NSLayoutYAxisAnchor? = nil) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = topAnchor {
            self.topAnchor.constraint(equalTo: top).isActive = true
        }
        if let leading = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leading).isActive = true
        }
        if let trailing = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailing).isActive = true
        }
        if let bottom = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottom).isActive = true
        }
        if let width = widthDimension {
            self.widthAnchor.constraint(equalTo: width).isActive = true
        }
        if let height = heightDimension {
            self.heightAnchor.constraint(equalTo: height).isActive = true
        }
        if let centerX = centerXAnchor {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerYAnchor {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }

    }

    func setAnchorsWithConstants(topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0, bottomAnchor: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat = 0, leadingAnchor: NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat = 0, trailingAnchor: NSLayoutXAxisAnchor? = nil, paddingTrailing: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = topAnchor {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let leading = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let trailing = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}
