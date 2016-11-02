//
//  EmptyContentView.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class EmptyContentView: UIView {

	/// Factory method of this class.
	static func view() -> EmptyContentView {
		
		let mainBundle = NSBundle.mainBundle()
		let nibs = mainBundle.loadNibNamed("EmptyContentView", owner: nil, options: nil)
		
		return nibs.first as? EmptyContentView ?? EmptyContentView()
	}
	
}
