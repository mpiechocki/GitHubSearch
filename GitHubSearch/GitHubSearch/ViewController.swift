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
	
	// MARK: - Initialization
	
	init() {
		searchBar = UISearchBar(frame: .zero)
		
		tableView = UITableView(frame: .zero)
		
		super.init(nibName: nil, bundle: nil)
		view.backgroundColor = UIColor.white
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

