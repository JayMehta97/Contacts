//
//  ContactDetail.swift
//  Contacts
//
//  Created by Jay Mehta on 06/01/20.
//  Copyright © 2020 Jay Mehta. All rights reserved.
//

import Foundation

struct ContactDetail {
    let detailType: ContactDetailType
    let detailLabel: String
    let detailValue: String
}

enum ContactDetailType {
    case number
    case address
    case email
    case birthDate
}
