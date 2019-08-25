//
//  IndividualsModel.swift
//  Code Challenge-LDS Church
//
//  Created by Christian R Monson on 8/22/19.
//  Copyright © 2019 christianrmonson. All rights reserved.
//

import Foundation

struct IndividualsData: Codable {
    let individuals: [Individual]
    struct Individual: Codable {
        let id: Int
        let firstName, lastName, birthdate: String
        let profilePicture: String
        let forceSensitive: Bool
        let affiliation: String
    }

}

