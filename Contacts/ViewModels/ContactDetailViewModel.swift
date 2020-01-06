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
    private var contactDetails = [ContactDetail]()

    let cellIdForContactDetailNameAndPhotoTableViewCell = "ContactDetailNameAndPhotoTableViewCell"
    let cellIdForContantDetailTableViewCell = "ContantDetailTableViewCell"


// MARK:- Data set up methods

    func setContact(contact: CNContact) {
        self.contact = contact
        setupAllDetails()
    }

    private func setupAllDetails() {
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

        setupBirthday()
    }

    private func setupBirthday() {
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


// MARK:- Helper methods

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
        // Value of detail is between _$!<>!$_ so we extract the import information by removing first and last 4 characters of it. Input value Ex :- _$!<Mobile>!$_
        var detail = value ?? "_$!<>!$_"
        if detail.count >= 8 {
            detail.removeFirst(4)
            detail.removeLast(4)
        }
        return detail.lowercased()
    }


// MARK:- Getter methods

    func getProfilePhoto() -> Data? {
        return contact.imageData
    }

    func getName() -> String {
        return contact.givenName + " " + contact.middleName + " " + contact.familyName
    }

    func getOrganizationName() -> String {
        return contact.organizationName
    }

    func getContactDetailsCount() -> Int {
        return contactDetails.count
    }

    func getContactDetail(forIndexPath indexPath: IndexPath) -> ContactDetail {
        return contactDetails[indexPath.row - 1]
    }
}
