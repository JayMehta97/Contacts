//
//  ContantDetailTableViewCell.swift
//  Contacts
//
//  Created by Jay Mehta on 06/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {

    let detailNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    let detailValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()

    var detailValueLabelHeightAnchorContraint = NSLayoutConstraint()

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
        self.addSubview(detailNameLabel)
        self.addSubview(detailValueLabel)
    }

    func addConstraintToViews() {
        detailNameLabel.setAnchorsWithConstants(topAnchor: topAnchor, paddingTop: 5, leadingAnchor: leadingAnchor, paddingLeading: 20, trailingAnchor: trailingAnchor, paddingTrailing: 10, height: 20)

        detailValueLabel.setAnchorsWithConstants(topAnchor: detailNameLabel.topAnchor, paddingTop: 15, leadingAnchor: leadingAnchor, paddingLeading: 20, trailingAnchor: trailingAnchor, paddingTrailing: 10)

        // Storing contraint to modify it later
        detailValueLabelHeightAnchorContraint = detailValueLabel.heightAnchor.constraint(equalToConstant: 40)
        detailValueLabelHeightAnchorContraint.isActive = true
    }

}
