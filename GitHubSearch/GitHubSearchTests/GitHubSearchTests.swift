//
//  GitHubSearchTests.swift
//  GitHubSearchTests
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import XCTest
@testable import GitHubSearch

class GitHubSearchTests: XCTestCase {
	
	var networkManager: MockNetworkManager!
	var tableViewViewModel: TableViewViewModel!
	var userDetailsViewModel: UserDetailsViewModel!
    
    override func setUp() {
        super.setUp()
		networkManager = MockNetworkManager()
		tableViewViewModel = TableViewViewModel(networkManager: networkManager)
		userDetailsViewModel = UserDetailsViewModel(networkManager: networkManager)
    }
    
    override func tearDown() {
		networkManager = nil
		tableViewViewModel = nil
		userDetailsViewModel = nil
        super.tearDown()
    }
	
	func testSearchCalls() {
		tableViewViewModel.loadData(searchText: "")
		XCTAssert(networkManager.searchUserCalled)
		XCTAssert(networkManager.searchRepositoriesCalled)
	}
	
	func testDetailsCalls() {
		userDetailsViewModel.loadUserDetails(username: "")
		XCTAssert(networkManager.getUserDetailsCalled)
		XCTAssert(networkManager.getUserStarredCountCalled)
		XCTAssert(networkManager.getImageCalled)
	}
}
