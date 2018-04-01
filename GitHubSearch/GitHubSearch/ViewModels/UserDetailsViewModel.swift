//
//  UserDetailsViewModel.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 31/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserDetailsViewModelProtocol {
	var username: Variable<String> { get }
	var avatar: Variable<UIImage> { get }
	var followersCount: Variable<Int> { get }
	var starredCount: Variable<Int> { get }
	
	func loadUserDetails(username: String)
}

class UserDetailsViewModel: UserDetailsViewModelProtocol {
	
	// MARK: - Properties
	
	let username: Variable<String>
	let avatar: Variable<UIImage>
	let followersCount: Variable<Int>
	let starredCount: Variable<Int>
	
	let networkManager: NetworkManaging
	
	// MARK: - Initialization
	
	init(networkManager: NetworkManaging = NetworkManager()) {
		self.networkManager = networkManager
		username = Variable("")
		avatar = Variable(#imageLiteral(resourceName: "blankUserImage"))
		followersCount = Variable(0)
		starredCount = Variable(0)
	}
	
	// MARK: - Methods
	
	func loadUserDetails(username: String) {
		networkManager.getUserDetails(username: username) { [weak self] (userDetails) in
			guard let `self` = self else { return }
			guard let userDetails = userDetails else { return }
			self.username.value = userDetails.login
			self.followersCount.value = userDetails.followers
			
			self.networkManager.getImage(url: userDetails.avatar_url) { [weak self] image in
				guard let `self` = self else { return }
				guard let image = image else { return }
				self.avatar.value = image
			}
		}
		
		networkManager.getUserStarredCount(username: username) { [weak self] (count) in
			guard let `self` = self else { return }
			guard let count = count else { return }
			self.starredCount.value = count
		}
	}
}
