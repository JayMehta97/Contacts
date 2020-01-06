//
//  ContactDetailNameAndPhotoTableViewCell.swift
//  Contacts
//
//  Created by Jay Mehta on 06/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit

class ContactDetailNameAndPhotoTableViewCell: UITableViewCell {

    let contactPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()

    let organizationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .gray
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
        self.addSubview(contactPhotoImageView)
        self.addSubview(nameLabel)
        self.addSubview(organizationNameLabel)
    }

    func addConstraintToViews() {
        contactPhotoImageView.setAnchorsWithConstants(topAnchor: topAnchor, paddingTop: 20, width: 100, height: 100)
        contactPhotoImageView.setAnchorsWithoutConstants(centerXAnchor: centerXAnchor)

        nameLabel.setAnchorsWithConstants(topAnchor: contactPhotoImageView.bottomAnchor, paddingTop: 10, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, height: 30)

        organizationNameLabel.setAnchorsWithConstants(topAnchor: nameLabel.bottomAnchor, paddingTop: 4, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, height: 20)
    }

}
