//
//  ContactsTableViewCell.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        addConstraintToViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        self.addSubview(label)
    }

    func addConstraintToViews() {
        label.setAnchorsWithConstants(leadingAnchor: self.leadingAnchor, paddingLeading: 20, height: 30)
        label.setAnchorsWithoutConstants(trailingAnchor: self.trailingAnchor, centerYAnchor: self.centerYAnchor)
    }

}
