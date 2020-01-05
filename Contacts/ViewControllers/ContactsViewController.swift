//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {

    private let indexLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    private let cellId = "ContactsTableViewCell"

    private let contacts = [[CNContact]]()
    private let titleForVC = "Contacts"

    let contactsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = titleForVC
        self.navigationController?.navigationBar.prefersLargeTitles = true

        addSubviews()
        addConstraints()

        contactsTableView.dataSource = self
        contactsTableView.delegate = self

        contactsTableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: cellId)

        fetchContacts()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addressBookDidChange),
            name: NSNotification.Name.CNContactStoreDidChange,
            object: nil)
    }

    func addSubviews() {
        view.addSubview(contactsTableView)
    }

    func addConstraints() {
        contactsTableView.setContraintsWithoutConstants(topConstraint: self.view.topAnchor, leadingConstraint: self.view.leadingAnchor, trailingConstraint: self.view.trailingAnchor, bottomConstraint: self.view.bottomAnchor)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


// MARK:- TableView DataSource events

extension ContactsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
//        return sectionsWithContact.count
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactsTableViewCell = contactsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ContactsTableViewCell else {
            return UITableViewCell()
        }

        contactsTableViewCell.label.text = "Hello World"
        return contactsTableViewCell
    }

}


// MARK:- TableView Delegate events

extension ContactsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray5
            return view
        }()

        let initialLetterLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.text = indexLetters[section]
            return label
        }()

        headerView.addSubview(initialLetterLabel)

        initialLetterLabel.setContraintsWithConstants(leadingConstraint: headerView.leadingAnchor, paddingLeading: 20, trailingConstraint: headerView.trailingAnchor, height: 20)
        initialLetterLabel.setContraintsWithoutConstants(centerYConstraint: headerView.centerYAnchor)

        return headerView
    }

}


// MARK:- Contacts fetching related events

extension ContactsViewController {

    func fetchContacts() {
        let isPermissionGranted = getPermissionForContacts()
        if isPermissionGranted {
            print("User  granted permission for contacts")

            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

            do {
                let store = CNContactStore()
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in

                    print(contact.givenName)
                    print(contact.familyName)
                    print(contact.phoneNumbers.first?.value.stringValue ?? "")
                })
            } catch let err {
                print("Failed to enumerate contacts due to error \(err)")
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

    @objc func addressBookDidChange(notification: NSNotification){
        fetchContacts()
    }

}



