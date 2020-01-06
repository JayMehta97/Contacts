//
//  ContactsViewModel.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Contacts
import Foundation

class ContactsViewModel {

    let titleForVC = "Contacts"
    let cellId = "ContactsTableViewCell"

    private let indexLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    private let unnamedString = "#"

    private var sectionTitleForContacts = [String]()
    private var contacts = [[CNContact]]()


    // MARK: - Helper methods

    private func setData(fromContactsResult contactsResult: [String: [CNContact]]) {
        for key in contactsResult.keys.sorted() where key != self.unnamedString {
            sectionTitleForContacts.append(key)
            contacts.append(contactsResult[key]?.sorted { (contactA: CNContact, contactB: CNContact) -> Bool in
                let nameA = contactA.givenName + contactA.familyName
                let nameB = contactB.givenName + contactB.familyName

                return nameA.uppercased() < nameB.uppercased()
            } ?? []
            )
        }

        if let unnamedContacts = contactsResult[self.unnamedString] {
            sectionTitleForContacts.append(self.unnamedString)
            contacts.append(unnamedContacts)
        }
    }

    private func clearData() {
        sectionTitleForContacts.removeAll()
        contacts.removeAll()
    }


    // MARK: - Contacts fetch methods

    func fetchContacts() {
        clearData()

        let store = CNContactStore()

        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactIdentifierKey, CNContactMiddleNameKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactOrganizationNameKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

        var contactsWithInitials = [String: [CNContact]]()

        do {
            try store.enumerateContacts(with: request) { (contact: CNContact, _) in
                var contactInitial = contact.givenName.first?.description.uppercased() ?? contact.familyName.first?.description.uppercased() ?? self.unnamedString
                if !self.indexLetters.contains(contactInitial) {
                    contactInitial = self.unnamedString
                }

                contactsWithInitials[contactInitial]?.append(contact)

                if contactsWithInitials[contactInitial] == nil {
                    contactsWithInitials[contactInitial] = [contact]
                }
            }

            self.setData(fromContactsResult: contactsWithInitials)
        } catch let err {
            print("Failed to enumerate contacts due to error \(err)")
        }
    }


    // MARK: - Data extraction methods

    func getNumberOfSectionsForContacts() -> Int {
        return sectionTitleForContacts.count
    }

    func getSectionTitle(forSection section: Int) -> String {
        return sectionTitleForContacts[section]
    }

    func getNumberOfContacts(forSection section: Int) -> Int {
        return contacts[section].count
    }

    func getContactName(forIndexPath indexPath: IndexPath) -> String {
        let contact = contacts[indexPath.section][indexPath.row]
        var contactName = contact.givenName + " " + contact.familyName

        if (contact.givenName + contact.familyName).isEmpty {
            contactName = contact.phoneNumbers.first?.value.stringValue ?? ""
        }

        return contactName
    }

    func getContact(forIndexPath indexPath: IndexPath) -> CNContact {
        return contacts[indexPath.section][indexPath.row]
    }

    func getAllSectionTitles() -> [String] {
        return sectionTitleForContacts
    }
}
