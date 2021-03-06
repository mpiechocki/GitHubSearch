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

protocol TableViewItemDisplayable {
	var id: Int { get }
	var description: String { get }
	var isUser: Bool { get }
}

enum TableViewItem: TableViewItemDisplayable {
	case user(user: User)
	case repository(repository: Repository)
	
	var id: Int {
		switch self {
		case .user(let user): return user.id
		case .repository(let repository): return repository.id
		}
	}
	
	var description: String {
		switch self {
		case .user(let user): return user.login
		case .repository(let repository): return repository.name
		}
	}
	
	var isUser: Bool {
		switch self {
		case .user: return true
		default: return false
		}
	}
}

protocol TableViewViewModelProtocol {
	var items: Observable<[TableViewItemDisplayable]> { get }
	var users: Variable<[User]> { get }
	var repositories: Variable<[Repository]> { get }
	var showError: (() -> Void)? { get set }
	
	func loadData(searchText: String)
}

class TableViewViewModel: TableViewViewModelProtocol {
	
	// MARK: - Properties
	
	var items: Observable<[TableViewItemDisplayable]>
	var users: Variable<[User]>
	var repositories: Variable<[Repository]>
	let networkManager: NetworkManaging
	var showError: (() -> Void)?
	
	// MARK: - Initialization
	
	init(networkManager: NetworkManaging = NetworkManager()) {
		self.networkManager = networkManager
		users = Variable([])
		repositories = Variable([])
		
		items = Observable.combineLatest(users.asObservable(), repositories.asObservable()) { (u, r) in
			let usersItems = u.map { TableViewItem.user(user: $0) }
			let repositoriesItems = r.map { TableViewItem.repository(repository: $0) }
			let sum = usersItems + repositoriesItems
			return sum.sorted { (lhs, rhs) in
				return lhs.id < rhs.id
			}
		}
	}
	
	// MARK: - Methods
	
	func loadData(searchText: String) {
		networkManager.searchUsers(searchText: searchText) { [weak self] (users) in
			guard let `self` = self else { return }
			guard let users = users else { self.showError?(); return }
			self.users.value = users
		}
		networkManager.searchRepositories(searchText: searchText) { [weak self] (repositories) in
			guard let `self` = self else { return }
			guard let repositories = repositories else { self.showError?(); return }
			self.repositories.value = repositories
		}
	}
}
