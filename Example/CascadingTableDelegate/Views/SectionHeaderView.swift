//
//  SectionHeaderView.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

	@IBOutlet private weak var headerLabel: UILabel!
	
	/**
	Preferred height for displaying this class' instance.
	
	- returns: `CGFloat` value.
	*/
	static func preferredHeight() -> CGFloat {
		return CGFloat(41)
	}
	
	static func view(headerText headerText: String) -> SectionHeaderView {
		
		let mainBundle = NSBundle.mainBundle()
		let nibs = mainBundle.loadNibNamed("SectionHeaderView", owner: nil, options: nil)
		
		if let headerView = nibs.first as? SectionHeaderView {
			
			headerView.configure(headerText: headerText)
			return headerView
		}
		
		let headerView = SectionHeaderView()
		headerView.configure(headerText: headerText)
		
		return headerView
	}			
	
	override func awakeFromNib() {
		super.awakeFromNib()
		headerLabel?.text = nil
	}
	
	func configure(headerText headerText: String) {
		headerLabel?.text = headerText
	}
}
