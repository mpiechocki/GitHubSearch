//
//  MockTableViewViewModel.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 01/04/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation
import RxSwift

class MockTableViewViewModel: TableViewViewModelProtocol {
	
	var items: Observable<[TableViewItemDisplayable]>
	var users: Variable<[User]>
	var repositories: Variable<[Repository]>
	var showError: (() -> Void)?
	
	init() {
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
		
		showError = nil
	}
	
	func loadData(searchText: String) {
		let user1 = User(id: 0, login: "user1")
		let repo1 = Repository(id: 1, name: "repo1")
		let user2 = User(id: 2, login: "user2")
		let repo2 = Repository(id: 2, name: "repo2")
		
		users.value = [user1, user2]
		repositories.value = [repo1, repo2]
	}
}
