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
	
	init() {
		disposeBag = DisposeBag()
		
		searchBar = UISearchBar(frame: .zero)
		
		tableView = UITableView(frame: .zero)
		tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
		
		viewModel = TableViewViewModel(items: [])
		
		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = UIColor.white
		
		setupLayout()
		setupTableView()
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
	
	// MARK: - Setup
	
	private func setupTableView() {
		viewModel
			.items
			.asObservable()
			.bind(
				to: tableView.rx.items(
					cellIdentifier: TableViewCell.reuseId,
					cellType: TableViewCell.self)) { (row, element, cell) in
						cell.setup(title: element.description)
			}.disposed(by: disposeBag)
		viewModel.loadData()
	}
}
