//
//  ViewController.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
	
	// MARK: - Views
	
	let searchBar: UISearchBar
	let tableView: UITableView
	
	// MARK: - ViewModel
	
	let viewModel: TableViewViewModelProtocol
	
	// MARK: - Initialization
	
	init() {
		searchBar = UISearchBar(frame: .zero)
		
		tableView = UITableView(frame: .zero)
		tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
		
		let items: [TableViewItemProtocol] = [
			TableViewItem.user(user: User(firstName: "Michael", lastName: "Jackson")),
			TableViewItem.user(user: User(firstName: "Rod", lastName: "Steward")),
			TableViewItem.repository(repository: Repository(name: "NewRepo"))
		]
		viewModel = TableViewViewModel(items: items)
		
		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = UIColor.white
		tableView.dataSource = self
		
		setupLayout()
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
}

extension ViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard section == 0 else { return 0 }
		return viewModel.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId) as? TableViewCell else { return UITableViewCell(frame: .zero) }
		let item = viewModel.items[indexPath.row]
		cell.setup(title: item.description)
		return cell
	}
}

