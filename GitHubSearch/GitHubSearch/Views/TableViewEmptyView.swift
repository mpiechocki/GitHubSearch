//
//  TableViewEmptyView.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 02/04/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import UIKit
import SnapKit

class TableViewEmptyView: UIView {
	
	let label: UILabel
	
	override init(frame: CGRect) {
		label = UILabel()
		label.text = "There are no search results ;("
		label.font = UIFont.italicSystemFont(ofSize: 15.0)
		
		super.init(frame: frame)
		
		backgroundColor = UIColor.white
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupLayout() {
		addSubview(label)
		label.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
}
