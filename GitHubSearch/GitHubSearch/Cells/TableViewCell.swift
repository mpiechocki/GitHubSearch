//
//  TableViewCell.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
	
	// MARK: - Statics
	
	static let reuseId = "TableViewCell"
	
	// MARK: - Views
	
	let titleLabel: UILabel
	
	// MARK: - Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		titleLabel = UILabel()
		super.init(style: .default, reuseIdentifier: TableViewCell.reuseId)
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Layout
	
	private func setupLayout() {
		contentView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints {
			$0.left.equalToSuperview().inset(20.0)
			$0.right.equalToSuperview().inset(20.0)
			$0.top.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
	}
	
	// MARK: - Setup
	
	func setup(title: String, isBold: Bool) {
		titleLabel.text = title
		if isBold {
			titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
		} else {
			titleLabel.font = UIFont.systemFont(ofSize: 15.0)
		}
	}
}
