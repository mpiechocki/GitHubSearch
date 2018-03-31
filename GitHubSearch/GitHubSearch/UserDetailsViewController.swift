//
//  UserDetailsViewController.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 31/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class UserDetailsViewController: UIViewController {
	
	// MARK: - Views
	
	let stackView: UIStackView
	let usernameLabel: UILabel
	let avatarImageView: UIImageView
	let followersCountLabel: UILabel
	let starredCountLabel: UILabel
	
	// MARK: - Properties
	
	let username: String
	let viewModel: UserDetailsViewModelProtocol
	let disposeBag: DisposeBag
	
	// MARK: - Initialization
	
	init(username: String, viewModel: UserDetailsViewModelProtocol = UserDetailsViewModel()) {
		self.viewModel = viewModel
		self.username = username
		disposeBag = DisposeBag()
		
		stackView = UIStackView(frame: .zero)
		stackView.axis = .vertical
		usernameLabel = UILabel()
		usernameLabel.text = "username"
		avatarImageView = UIImageView(frame: .zero)
		followersCountLabel = UILabel()
		followersCountLabel.text = "\(0) followers"
		starredCountLabel = UILabel()
		starredCountLabel.text = "\(0) stars"
		
		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = UIColor.white
		
		setupLayout()
		bindViewModel()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		viewModel.loadUserDetails(username: username)
	}
	
	// MARK: - Layout
	
	private func setupLayout() {
		stackView.addArrangedSubview(usernameLabel)
		stackView.addArrangedSubview(avatarImageView)
		stackView.addArrangedSubview(followersCountLabel)
		stackView.addArrangedSubview(starredCountLabel)
		
		view.addSubview(stackView)
		stackView.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
	
	// MARK: - Setup
	
	private func bindViewModel() {
		viewModel
			.username
			.asObservable()
			.bind(to: usernameLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel
			.followersCount
			.asObservable()
			.subscribe(onNext: { [weak self] (followersCount) in
				guard let `self` = self else { return }
				self.followersCountLabel.text = "\(followersCount) followers"
			}, onError: nil, onCompleted: nil, onDisposed: nil)
			.disposed(by: disposeBag)
		
		viewModel
			.starredCount
			.asObservable()
			.subscribe(onNext: { [weak self] (starredCount) in
				guard let `self` = self else { return }
				self.starredCountLabel.text = "\(starredCount) stars"
			}, onError: nil, onCompleted: nil, onDisposed: nil)
			.disposed(by: disposeBag)
		
		viewModel
			.avatar
			.asObservable()
			.bind(to: avatarImageView.rx.image)
			.disposed(by: disposeBag)
	}
}
