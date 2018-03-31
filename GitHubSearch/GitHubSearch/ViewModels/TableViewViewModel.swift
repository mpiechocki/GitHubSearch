//
//  TableViewViewModel.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TableViewItemProtocol {
	var description: String { get }
	var shouldBeBold: Bool { get }
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
	
	var shouldBeBold: Bool {
		switch self {
		case .user: return false
		case .repository: return true
		}
	}
}

protocol TableViewViewModelProtocol {
	var items: Observable<[TableViewItemProtocol]> { get }
	var users: Variable<[User]> { get }
	var repositories: Variable<[Repository]> { get }
	func loadData(searchText: String)
}

class TableViewViewModel: TableViewViewModelProtocol {
	
	// MARK: - Properties
	
	var items: Observable<[TableViewItemProtocol]>
	var users: Variable<[User]>
	var repositories: Variable<[Repository]>
	let networkManager: NetworkManaging
	
	// MARK: - Initialization
	
	init(networkManager: NetworkManaging = NetworkManager()) {
		self.networkManager = networkManager
		users = Variable([])
		repositories = Variable([])
		
		// @TODO: sortowanie
		
		items = Observable.combineLatest(users.asObservable(), repositories.asObservable()) { (u, r) in
			let usersItems = u.map { TableViewItem.user(user: $0) }
			let repositoriesItems = r.map { TableViewItem.repository(repository: $0) }
			return usersItems + repositoriesItems
		}
	}
	
	func loadData(searchText: String) {
		networkManager.searchUsers(searchText: searchText) { [weak self] (users) in
			guard let `self` = self else { return }
			self.users.value = users
		}
		networkManager.searchRepositories(searchText: searchText) { [weak self] (repositories) in
			guard let `self` = self else { return }
			self.repositories.value = repositories
		}
	}
}
