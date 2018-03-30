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
		case .user(let user): return user.login
		case .repository(let repository): return repository.name
		}
	}
}

protocol TableViewViewModelProtocol {
	var items: Variable<[TableViewItemProtocol]> { get }
	func loadData(searchText: String)
}

class TableViewViewModel: TableViewViewModelProtocol {
	
	// MARK: - Properties
	
	var items: Variable<[TableViewItemProtocol]>
	let networkManager: NetworkManaging
	
	// MARK: - Initialization
	
	init(networkManager: NetworkManaging = NetworkManager()) {
		self.items = Variable([])
		self.networkManager = networkManager
	}
	
	func loadData(searchText: String) {
		networkManager.search(searchText: searchText) { [weak self] (newItems) in
			guard let `self` = self else { return }
			self.items.value = newItems
		}
	}
}
