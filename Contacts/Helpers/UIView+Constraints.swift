//
//  UIView+Constraints.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit

extension UIView {

    func setContraintsWithoutConstants(topConstraint: NSLayoutYAxisAnchor? = nil, leadingConstraint: NSLayoutXAxisAnchor? = nil, trailingConstraint: NSLayoutXAxisAnchor? = nil, bottomConstraint: NSLayoutYAxisAnchor? = nil, widthConstraint: NSLayoutDimension? = nil, heightConstraint: NSLayoutDimension? = nil, centerXConstraint: NSLayoutXAxisAnchor? = nil, centerYConstraint: NSLayoutYAxisAnchor? = nil) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = topConstraint {
            self.topAnchor.constraint(equalTo: top).isActive = true
        }
        if let leading = leadingConstraint {
            self.leadingAnchor.constraint(equalTo: leading).isActive = true
        }
        if let trailing = trailingConstraint {
            self.trailingAnchor.constraint(equalTo: trailing).isActive = true
        }
        if let bottom = bottomConstraint {
            self.bottomAnchor.constraint(equalTo: bottom).isActive = true
        }
        if let width = widthConstraint {
            self.widthAnchor.constraint(equalTo: width).isActive = true
        }
        if let height = heightConstraint {
            self.heightAnchor.constraint(equalTo: height).isActive = true
        }
        if let centerX = centerXConstraint {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerYConstraint {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }

    }

    func setContraintsWithConstants(topConstraint: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0, bottomConstraint: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat = 0, leadingConstraint: NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat = 0, trailingConstraint: NSLayoutXAxisAnchor? = nil, paddingTrailing: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = topConstraint {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottomConstraint {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let leading = leadingConstraint {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let trailing = trailingConstraint {
            trailingAnchor.constraint(equalTo: trailing, constant: paddingTrailing).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}
