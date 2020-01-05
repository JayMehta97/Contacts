//
//  ContactsViewModel.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Foundation
import Contacts

class ContactsViewModel {

    let titleForVC = "Contacts"
    let cellId = "ContactsTableViewCell"

    private var sectionTitleForContacts = [String]()
    private var contacts = [[CNContact]]()

    func getNumberOfSectionsForContacts() -> Int {
        return sectionTitleForContacts.count
    }

    func getSectionTitle(forSection section: Int) -> String {
        return sectionTitleForContacts[section]
    }

    func getNumberOfContacts(forSection section: Int) -> Int {
        return contacts[section].count
    }

    func getContactName(forIndexPath indexPath: IndexPath) -> String{
        let contact = contacts[indexPath.section][indexPath.row]
        var contactName = contact.givenName + " " + contact.familyName

        if (contact.givenName + contact.familyName).isEmpty {
            contactName = contact.phoneNumbers.first?.value.stringValue ?? ""
        }

        return contactName
    }

    func clearData() {
        sectionTitleForContacts.removeAll()
        contacts.removeAll()
    }


    // MARK:- Contacts fetching related events
    func fetchContacts() {
        let isPermissionGranted = getPermissionForContacts()

        if isPermissionGranted {
            print("User  granted permission for contacts")

            let store = CNContactStore()

            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactNoteKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactIdentifierKey, CNContactMiddleNameKey, CNContactInstantMessageAddressesKey, CNContactUrlAddressesKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactOrganizationNameKey, CNContactImageDataAvailableKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

            var contactsWithInitials = Dictionary<String, [CNContact]>()

            do {
                try store.enumerateContacts(with: request, usingBlock: { (contact, pointerToTerminateEnumeration) in

                    let contactInitial = contact.givenName.first?.description ?? contact.familyName.first?.description ?? "Unnamed"
                    contactsWithInitials[contactInitial]?.append(contact)

                    if contactsWithInitials[contactInitial] == nil {
                        contactsWithInitials[contactInitial] = [contact]
                    }
                })

            } catch let err {
                print("Failed to enumerate contacts due to error \(err)")
            }

            for key in contactsWithInitials.keys.sorted() {
                if key != "Unnamed" {
                    sectionTitleForContacts.append(key)
                    contacts.append(contactsWithInitials[key]?.sorted(by: { (contactA, contactB) -> Bool in
                        let nameA = contactA.givenName + contactA.familyName
                        let nameB = contactB.givenName + contactB.familyName

                        return nameA < nameB
                    }) ?? [])
                }
            }

            if let unnamedContacts = contactsWithInitials["Unnamed"] {
                sectionTitleForContacts.append("Unnamed")
                contacts.append(unnamedContacts)
            }

        } else {
            print("Access denied..")
        }
    }

    func getPermissionForContacts() -> Bool {
        let store = CNContactStore()
        var permission = false

        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access with error \(err)")
                return
            }
            permission = granted
        }
        return permission
    }
}
