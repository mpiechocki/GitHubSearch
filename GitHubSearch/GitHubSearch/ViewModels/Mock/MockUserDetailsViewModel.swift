//
//  MockUserDetailsViewModel.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 01/04/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation
import RxSwift

class MockUserDetailsViewModel: UserDetailsViewModelProtocol {
	var username: Variable<String>
	var avatar: Variable<UIImage>
	var followersCount: Variable<Int>
	var starredCount: Variable<Int>
	
	init() {
		username = Variable("")
		avatar = Variable(#imageLiteral(resourceName: "blankUserImage"))
		followersCount = Variable(0)
		starredCount = Variable(0)
	}
	
	func loadUserDetails(username: String) {
		self.username.value = "Username"
		avatar.value = #imageLiteral(resourceName: "testUserImage")
		followersCount.value = 99
		starredCount.value = 88
	}
}
