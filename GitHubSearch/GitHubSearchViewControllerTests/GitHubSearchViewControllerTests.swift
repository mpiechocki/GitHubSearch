//
//  GitHubSearchViewControllerTests.swift
//  GitHubSearchViewControllerTests
//
//  Created by dontgonearthecastle on 01/04/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import XCTest

class GitHubSearchViewControllerTests: XCTestCase {
    
	var viewController: ViewController!
	var tableViewViewModel: MockTableViewViewModel!
	
	override func setUp() {
		super.setUp()
		tableViewViewModel = MockTableViewViewModel()
		viewController = ViewController(viewModel: tableViewViewModel)
	}
	
	override func tearDown() {
		tableViewViewModel = nil
		viewController = nil
		super.tearDown()
	}
	
	func testViewController() {
		tableViewViewModel.loadData(searchText: "")
		
		guard let cell1 = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell else { XCTFail(); return }
		XCTAssert(cell1.titleLabel.text == "u: user1")
		
		guard let cell2 = viewController.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TableViewCell else { XCTFail(); return }
		XCTAssert(cell2.titleLabel.text == "r: repo1")
		
		guard let cell3 = viewController.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TableViewCell else { XCTFail(); return }
		XCTAssert(cell3.titleLabel.text == "u: user2")
		
		guard let cell4 = viewController.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TableViewCell else { XCTFail(); return }
		XCTAssert(cell4.titleLabel.text == "r: repo2")
	}
}
