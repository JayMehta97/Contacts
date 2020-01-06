//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Jay Mehta on 06/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    let contactDetailVM = ContactDetailViewModel()

    let contactDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        addSubviews()
        addConstraints()

        contactDetailTableView.dataSource = self
        contactDetailTableView.delegate = self

        contactDetailTableView.register(ContactDetailNameAndPhotoTableViewCell.self, forCellReuseIdentifier: contactDetailVM.cellIdForContactDetailNameAndPhotoTableViewCell)
        contactDetailTableView.register(ContantDetailTableViewCell.self, forCellReuseIdentifier: contactDetailVM.cellIdForContantDetailTableViewCell)
    }

    private func addSubviews() {
        view.addSubview(contactDetailTableView)
    }

    private func addConstraints() {
        contactDetailTableView.setContraintsWithoutConstants(topConstraint: self.view.topAnchor, leadingConstraint: self.view.leadingAnchor, trailingConstraint: self.view.trailingAnchor, bottomConstraint: self.view.bottomAnchor)
    }

}


// MARK:- TableView DataSource events

extension ContactDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetailVM.contactDetails.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let contactDetailNameAndPhotoTableViewCell = contactDetailTableView.dequeueReusableCell(withIdentifier: contactDetailVM.cellIdForContactDetailNameAndPhotoTableViewCell, for: indexPath) as? ContactDetailNameAndPhotoTableViewCell else {
                return UITableViewCell()
            }

            if let imageData = contactDetailVM.getProfilePhoto() {
                contactDetailNameAndPhotoTableViewCell.contactPhotoImageView.image = UIImage(data: imageData)
            } else {
                contactDetailNameAndPhotoTableViewCell.contactPhotoImageView.image = #imageLiteral(resourceName: "profile-icon")
            }

            contactDetailNameAndPhotoTableViewCell.nameLabel.text = contactDetailVM.getName()
            contactDetailNameAndPhotoTableViewCell.organizationNameLabel.text = contactDetailVM.getOrganizationName()

            return contactDetailNameAndPhotoTableViewCell
        }

        guard let contactDetailTableViewCell = contactDetailTableView.dequeueReusableCell(withIdentifier: contactDetailVM.cellIdForContantDetailTableViewCell, for: indexPath) as? ContantDetailTableViewCell else {
            return UITableViewCell()
        }

        contactDetailTableViewCell.detailNameLabel.text = contactDetailVM.contactDetails[indexPath.row - 1].detailLabel
        contactDetailTableViewCell.detailValueLabel.text = contactDetailVM.contactDetails[indexPath.row - 1].detailValue

        if contactDetailVM.contactDetails[indexPath.row - 1].detailType == .address {
            let height = contactDetailVM.getHeightForView(text: contactDetailVM.contactDetails[indexPath.row - 1].detailValue, font: UIFont.systemFont(ofSize: 17), width: tableView.frame.width)
            contactDetailTableViewCell.detailValueLabel.heightAnchor.constraint(equalToConstant: height + 20).isActive = true
        } else {
            contactDetailTableViewCell.detailValueLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }

        print(contactDetailVM.contactDetails[indexPath.row - 1].detailValue)

        return contactDetailTableViewCell
    }

}


// MARK:- TableView Delegate events

extension ContactDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (contactDetailVM.getOrganizationName().isEmpty) ? 170 : 200
        } else if contactDetailVM.contactDetails[indexPath.row - 1].detailType == .address {
            let height = contactDetailVM.getHeightForView(text: contactDetailVM.contactDetails[indexPath.row - 1].detailValue, font: UIFont.systemFont(ofSize: 17), width: tableView.frame.width)
            return height + 40
        } else {
            return 60
        }
    }
}
