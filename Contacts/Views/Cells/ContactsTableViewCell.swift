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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addSubviews() {
        self.addSubview(label)
    }

    func addConstraintToViews() {
        label.setContraintsWithConstants(leadingConstraint: self.leadingAnchor, paddingLeading: 20, height: 30)
        label.setContraintsWithoutConstants(trailingConstraint: self.trailingAnchor, centerYConstraint: self.centerYAnchor)
    }

}
