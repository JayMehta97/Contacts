//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Jay Mehta on 05/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    var contactsVM = ContactsViewModel()

    let contactsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = contactsVM.titleForVC
        self.navigationController?.navigationBar.prefersLargeTitles = true

        addSubviews()
        addConstraints()

        contactsTableView.dataSource = self
        contactsTableView.delegate = self

        contactsTableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: contactsVM.cellId)

        contactsVM.fetchContacts()

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

    @objc func addressBookDidChange(notification: NSNotification){
        contactsVM.clearData()
        contactsVM.fetchContacts()
        contactsTableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


// MARK:- TableView DataSource events

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
            label.text = contactsVM.getSectionTitle(forSection: section)
            return label
        }()

        headerView.addSubview(initialLetterLabel)

        initialLetterLabel.setContraintsWithConstants(leadingConstraint: headerView.leadingAnchor, paddingLeading: 20, trailingConstraint: headerView.trailingAnchor, height: 20)
        initialLetterLabel.setContraintsWithoutConstants(centerYConstraint: headerView.centerYAnchor)

        return headerView
    }

}



