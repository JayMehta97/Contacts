//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Jay Mehta on 06/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailViewController: UIViewController {

    let contactDetailVM = ContactDetailViewModel()

    private let contactDetailTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        addSubviews()
        addConstraints()

        contactDetailTableView.dataSource = self
        contactDetailTableView.delegate = self

        contactDetailTableView.tableFooterView = UIView()

        contactDetailTableView.register(ContactDetailNameAndPhotoTableViewCell.self, forCellReuseIdentifier: contactDetailVM.cellIdForContactDetailNameAndPhotoTableViewCell)
        contactDetailTableView.register(ContactDetailTableViewCell.self, forCellReuseIdentifier: contactDetailVM.cellIdForContantDetailTableViewCell)
    }

    private func addSubviews() {
        view.addSubview(contactDetailTableView)
    }

    private func addConstraints() {
        contactDetailTableView.setAnchorsWithoutConstants(topAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, trailingAnchor: self.view.trailingAnchor, bottomAnchor: self.view.bottomAnchor)
    }

    private func showActionSheetForNumber(withContact contact: ContactDetail) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            // Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)

        let callAction = UIAlertAction(title: "Call \(contact.detailLabel)", style: .default) { action -> Void in
            self.callContact(withNumber: contact.detailValue)
        }
        actionSheetController.addAction(callAction)

        // Create and add a second option action
        let messageAction = UIAlertAction(title: "Message \(contact.detailLabel)", style: .default) { action -> Void in
            self.sendMessage(toNumber: contact.detailValue)
        }
        actionSheetController.addAction(messageAction)

        self.present(actionSheetController, animated: true, completion: nil)
    }

    private func callContact(withNumber number: String) {
        let formatedNumber = number.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")

        print("Calling \(formatedNumber)")

        let phoneUrl = "tel://\(formatedNumber)"
        if let url = URL(string: phoneUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}


// MARK:- TableView DataSource events

extension ContactDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Contact details array does not contain data for image and name cell which is the first one. So we add its count explicitly (+1)
        return contactDetailVM.getContactDetailsCount() + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // If it is the first cell then we return the image, name and organisation detail cell
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

        guard let contactDetailTableViewCell = contactDetailTableView.dequeueReusableCell(withIdentifier: contactDetailVM.cellIdForContantDetailTableViewCell, for: indexPath) as? ContactDetailTableViewCell else {
            return UITableViewCell()
        }

        let contactDetail = contactDetailVM.getContactDetail(forIndexPath: indexPath)
        contactDetailTableViewCell.detailNameLabel.text = contactDetail.detailLabel
        contactDetailTableViewCell.detailValueLabel.text = contactDetail.detailValue

        if contactDetail.detailType == .address {
            // We calculate the height for label according to our text
            let height = contactDetailVM.getHeightForView(text: contactDetail.detailValue, font: contactDetailTableViewCell.detailValueLabel.font, width: tableView.frame.width)

            // We set the older constraint to inactive state and activate a new height constraint
            contactDetailTableViewCell.detailValueLabelHeightAnchorContraint.isActive = false
            contactDetailTableViewCell.detailValueLabel.heightAnchor.constraint(equalToConstant: height + 20).isActive = true
        }

        return contactDetailTableViewCell
    }

}


// MARK:- TableView Delegate events

extension ContactDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (contactDetailVM.getOrganizationName().isEmpty) ? 170 : 200
        } else if contactDetailVM.getContactDetail(forIndexPath: indexPath).detailType == .address {
            // We calculate the height for cell according to our text
            let height = contactDetailVM.getHeightForView(text: contactDetailVM.getContactDetail(forIndexPath: indexPath).detailValue, font: UIFont.systemFont(ofSize: 17), width: tableView.frame.width)
            return height + 40
        } else {
            return 60
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactDetailTableView.deselectRow(at: indexPath, animated: true)

        let contact = contactDetailVM.getContactDetail(forIndexPath: indexPath)
        
        if contact.detailType == .number {
            showActionSheetForNumber(withContact: contact)
        } else if contact.detailType == .email {
            sendEmail(toEmailAddress: contact.detailValue)
        }
    }
}


// MARK:- Send Message

extension ContactDetailViewController : MFMessageComposeViewControllerDelegate {

    private func sendMessage(toNumber number: String) {
        let formatedNumber = number.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")

        print("Messaging \(formatedNumber)")

        let messageVC = MFMessageComposeViewController()
        messageVC.recipients = [formatedNumber]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message was sent")
        default:
            break
        }

        dismiss(animated: true, completion: nil)
    }
}


// MARK:- Send Email

extension ContactDetailViewController: MFMailComposeViewControllerDelegate {

    func sendEmail(toEmailAddress emailAddress: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailAddress])

            present(mail, animated: true)
        } else {
            print("Failed to send mail")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case .cancelled:
            print("Mail was cancelled")
        case .failed:
            print("Mail failed")
        case .sent:
            print("Mail was sent")
        default:
            break
        }
        controller.dismiss(animated: true)
    }
}
