//
//  EmptyContentView.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class EmptyContentView: UIView {

	/// Factory method of this class.
	static func view() -> EmptyContentView {
		
		let mainBundle = Bundle.main
		let nibs = mainBundle.loadNibNamed("EmptyContentView", owner: nil, options: nil)
		
		return nibs!.first as? EmptyContentView ?? EmptyContentView()
	}
	
}
