//
//  Endpoints.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation

enum Endpoint {
	case searchUsers
	case searchRepositories
	case userDetails
	case starred
	
	var urlString: String {
		switch self {
		case .searchUsers: return "https://api.github.com/search/users"
		case .searchRepositories: return "https://api.github.com/search/repositories"
		case .userDetails: return "https://api.github.com/users/{username}"
		case .starred: return "https://api.github.com/users/{username}/starred"
		}
	}
}
