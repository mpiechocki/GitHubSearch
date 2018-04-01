//
//  ViewController.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
	
	// MARK: - Views
	
	let searchBar: UISearchBar
	let tableView: UITableView
	
	// MARK: - ViewModel
	
	var viewModel: TableViewViewModelProtocol
	
	// MARK: - Properties
	
	var disposeBag: DisposeBag
	
	// MARK: - Initialization
	
	init(viewModel: TableViewViewModelProtocol = TableViewViewModel()) {
		disposeBag = DisposeBag()
		
		searchBar = UISearchBar(frame: .zero)
		tableView = UITableView(frame: .zero)
		tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
		
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = UIColor.white
		title = "GitHubSearch"
		
		setupLayout()
		configureTableView()
		configureSearchBar()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Layout
	
	private func setupLayout() {
		view.addSubview(searchBar)
		searchBar.snp.makeConstraints {
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			$0.height.equalTo(50.0)
		}
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints {
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
			$0.top.equalTo(searchBar.snp.bottom)
		}
	}
	
	// MARK: - Configuration
	
	private func configureTableView() {
		viewModel
			.items
			.asObservable()
			.bind(
				to: tableView.rx.items(
					cellIdentifier: TableViewCell.reuseId,
					cellType: TableViewCell.self)) { (row, element, cell) in
						cell.setup(title: element.description, isUser: element.isUser)
			}.disposed(by: disposeBag)
		
		tableView
			.rx
			.modelSelected(TableViewItemDisplayable.self)
			.subscribe(onNext: { [weak self] (item) in
				guard let `self` = self else { return }
				if item.isUser {
					let viewController = UserDetailsViewController(username: item.description)
					self.navigationController?.pushViewController(viewController, animated: true)
				}
			}, onError: nil, onCompleted: nil, onDisposed: nil)
			.disposed(by: disposeBag)
		
		_ = tableView.rx.setDelegate(self)
	}
	
	private func configureSearchBar() {
		searchBar.rx
			.text
			.orEmpty
			.throttle(0.8, scheduler: MainScheduler.instance)
			.distinctUntilChanged()
			.subscribe(onNext: { [weak self] (inputText) in
				guard let `self` = self else { return }
				self.viewModel.loadData(searchText: inputText)
				},
				onError: nil,
				onCompleted: nil,
				onDisposed: nil)
			.disposed(by: disposeBag)
		
		searchBar
			.rx
			.searchButtonClicked
			.subscribe(onNext: { [weak self] in
				guard let `self` = self else { return }
				self.searchBar.resignFirstResponder()
			}, onError: nil, onCompleted: nil, onDisposed: nil)
			.disposed(by: disposeBag)
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40.0
	}
}
