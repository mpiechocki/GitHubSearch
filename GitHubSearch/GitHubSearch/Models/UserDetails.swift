//
//  UserDetails.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 31/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation

struct UserDetails: Decodable {
	let id: Int
	let login: String
	let followers: Int
	let avatar_url: String
}
