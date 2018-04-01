//
//  GitHubSearchUserDetailsTests.swift
//  GitHubSearchUserDetailsTests
//
//  Created by dontgonearthecastle on 01/04/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import XCTest
@testable import GitHubSearch

class GitHubSearchUserDetailsTests: XCTestCase {
	
	var userDetailsViewController: UserDetailsViewController!
	var userDetailsViewModel: MockUserDetailsViewModel!
    
    override func setUp() {
        super.setUp()
		userDetailsViewModel = MockUserDetailsViewModel()
		userDetailsViewController = UserDetailsViewController(username: "", viewModel: userDetailsViewModel)
    }
    
    override func tearDown() {
        userDetailsViewModel = nil
		userDetailsViewController = nil
        super.tearDown()
    }
	
	func testUserDetailsViewController() {
		userDetailsViewModel.loadUserDetails(username: "")
		
		XCTAssert(userDetailsViewController.usernameLabel.text == "username: Username")
		XCTAssert(userDetailsViewController.followersCountLabel.text == "followers: 99")
		XCTAssert(userDetailsViewController.starredCountLabel.text == "stars: 88")
		XCTAssert(userDetailsViewController.avatarImageView.image == #imageLiteral(resourceName: "testUserImage"))
	}
}
