//
//  TableViewViewModel.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation
import RxSwift

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
	var items: Variable<[TableViewItemProtocol]> { get }
	func loadData()
}

class TableViewViewModel: TableViewViewModelProtocol {
	var items: Variable<[TableViewItemProtocol]>
	
	init(items: [TableViewItemProtocol]) {
		self.items = Variable(items)
	}
	
	func loadData() {
		let items: [TableViewItemProtocol] = [
			TableViewItem.user(user: User(firstName: "Michael", lastName: "Jackson")),
			TableViewItem.user(user: User(firstName: "Rod", lastName: "Steward")),
			TableViewItem.repository(repository: Repository(name: "NewRepo"))
		]
		self.items.value.append(contentsOf: items)
	}
}
