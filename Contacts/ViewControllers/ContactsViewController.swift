//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Contacts
import UIKit

class ContactsViewController: UIViewController {

    private let contactsVM = ContactsViewModel()

    private let contactsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.title = contactsVM.titleForVC

        addSubviews()
        addConstraints()

        contactsTableView.dataSource = self
        contactsTableView.delegate = self

        contactsTableView.tableFooterView = UIView()

        contactsTableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: contactsVM.cellId)

        askUserForContactsPermission()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addressBookDidChange),
            name: NSNotification.Name.CNContactStoreDidChange,
            object: nil
        )
    }

    private func addSubviews() {
        view.addSubview(contactsTableView)
    }

    private func addConstraints() {
        contactsTableView.setAnchorsWithoutConstants(topAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, trailingAnchor: self.view.trailingAnchor, bottomAnchor: self.view.bottomAnchor)
    }

    // Gets called when any modification is done in iOS contact app
    @objc private func addressBookDidChange(notification: NSNotification) {
        contactsVM.fetchContacts()
        contactsTableView.reloadData()
    }

    // First it will ask user for permission via a pop-up. Second time onwards it will persist the previous decision and give result accordingly
    private func askUserForContactsPermission() {
        let store = CNContactStore()

        store.requestAccess(for: .contacts) { (granted: Bool, err: Error?) in
            if let err = err {
                print("Failed to request access with error \(err)")
                return
            }

            if granted {
                print("User has granted permission for contacts")

                self.contactsVM.fetchContacts()

                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
            } else {
                print("Access denied..")
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


// MARK: - TableView DataSource events

extension ContactsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsVM.getNumberOfSectionsForContacts()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsVM.getNumberOfContacts(forSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactsTableViewCell = contactsTableView.dequeueReusableCell(withIdentifier: contactsVM.cellId, for: indexPath) as? ContactsTableViewCell else {
            return UITableViewCell()
        }

        contactsTableViewCell.label.text = contactsVM.getContactName(forIndexPath: indexPath)
        return contactsTableViewCell
    }

}


// MARK: - TableView Delegate events

extension ContactsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.8980000019, green: 0.8980000019, blue: 0.9179999828, alpha: 1)
            return view
        }()

        let initialLetterLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.text = contactsVM.getSectionTitle(forSection: section)
            return label
        }()

        headerView.addSubview(initialLetterLabel)

        initialLetterLabel.setAnchorsWithConstants(leadingAnchor: headerView.leadingAnchor, paddingLeading: 20, trailingAnchor: headerView.trailingAnchor, height: 20)
        initialLetterLabel.setAnchorsWithoutConstants(centerYAnchor: headerView.centerYAnchor)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactsTableView.deselectRow(at: indexPath, animated: true)

        let selectedContact = contactsVM.getContact(forIndexPath: indexPath)
        let contactDetailVC = ContactDetailViewController()

        contactDetailVC.contactDetailVM.setContact(contact: selectedContact)

        self.navigationController?.pushViewController(contactDetailVC, animated: true)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsVM.getAllSectionTitles()
    }

}
