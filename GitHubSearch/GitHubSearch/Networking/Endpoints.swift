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
	
	var urlString: String {
		switch self {
		case .searchUsers: return "https://api.github.com/search/users"
		case .searchRepositories: return "https://api.github.com/search/repositories"
		}
	}
}
