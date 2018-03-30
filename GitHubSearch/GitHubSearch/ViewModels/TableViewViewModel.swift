//
//  TableViewViewModel.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation

protocol TableViewItemProtocol {
	var description: String { get }
}

enum TableViewItem: TableViewItemProtocol {
	case user(user: User)
	case repository(repository: Repository)
	
	var description: String {
		switch self {
		case .user(let user): return user.firstName
		case .repository(let repository): return repository.name
		}
	}
}

protocol TableViewViewModelProtocol {
	var items: [TableViewItemProtocol] { get }
}

class TableViewViewModel: TableViewViewModelProtocol {
	var items: [TableViewItemProtocol]
	
	init(items: [TableViewItemProtocol]) {
		self.items = items
	}
}
