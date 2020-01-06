//
//  ContactDetailViewModel.swift
//  Contacts
//
//  Created by Jay Mehta on 06/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit
import Contacts

class ContactDetailViewModel {

    private var contact = CNContact()
    var contactDetails = [ContactDetail]()

    let cellIdForContactDetailNameAndPhotoTableViewCell = "ContactDetailNameAndPhotoTableViewCell"
    let cellIdForContantDetailTableViewCell = "ContantDetailTableViewCell"

    func setContact(contact: CNContact) {
        self.contact = contact
        setupDetails()
    }

    private func setupDetails() {
        for phoneNumber in contact.phoneNumbers {
            contactDetails.append(ContactDetail(detailType: .number, detailLabel: getDetailFromValue(value: phoneNumber.label), detailValue: phoneNumber.value.stringValue))
        }

        for email in contact.emailAddresses {
            contactDetails.append(ContactDetail(detailType: .email, detailLabel: getDetailFromValue(value: email.label), detailValue: email.value as String))
        }

        for address in contact.postalAddresses {
            let fullAddress = address.value.street + "\n" + address.value.city + " " + address.value.state + " " + address.value.postalCode + "\n" + address.value.country

            contactDetails.append(ContactDetail(detailType: .address, detailLabel: getDetailFromValue(value: address.label), detailValue: fullAddress))
        }

        if let birthday = contact.birthday {
            var date = ""

            if let monthInNumber = birthday.month {
                date = DateFormatter().monthSymbols[monthInNumber]
            }

            if let day = birthday.day {
                date += " \(day.description)"
            }

            if let year = birthday.year {
                date += ", \(year)"
            }

            contactDetails.append(ContactDetail(detailType: .birthDate, detailLabel: "birthday", detailValue: date))
        }
    }

    func getHeightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }

    private func getDetailFromValue(value: String?) -> String {
        var detail = value ?? "_$!<>!$_"
        detail.removeFirst(4)
        detail.removeLast(4)
        return detail
    }

    func getProfilePhoto() -> Data? {
        return contact.imageData
    }

    func getName() -> String {
        return contact.givenName + " " + contact.middleName + " " + contact.familyName
    }

    func getOrganizationName() -> String {
        return contact.organizationName
    }
}
