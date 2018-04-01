//
//  MockNetworkManager.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 01/04/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation
import UIKit

class MockNetworkManager: NetworkManaging {
	var searchUserCalled = false
	var searchRepositoriesCalled = false
	var getUserDetailsCalled = false
	var getUserStarredCountCalled = false
	var getImageCalled = false
	
	func searchUsers(searchText: String, completion: @escaping ([User]?) -> Void) {
		searchUserCalled = true
	}
	
	func searchRepositories(searchText: String, completion: @escaping ([Repository]?) -> Void) {
		searchRepositoriesCalled = true
	}
	
	func getUserDetails(username: String, completion: @escaping (UserDetails?) -> Void) {
		getUserDetailsCalled = true
		let userDetails = UserDetails(id: 0, login: "", followers: 0, avatar_url: "url")
		completion(userDetails)
	}
	
	func getUserStarredCount(username: String, completion: @escaping (Int?) -> Void) {
		getUserStarredCountCalled = true
	}
	
	func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
		getImageCalled = true
	}
}
