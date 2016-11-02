//
//  UITableView+RefreshControl.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

extension UITableView {
	
	/**
	Configures this instance's offset to show its `UIRefreshControl`, if it had one.
	*/
	func showRefreshControl() {
		
		let topContentInset = -CGFloat(120)
		
		let refreshOffset = CGPoint(x: 0, y: topContentInset)
		self.setContentOffset(refreshOffset, animated: true)
	}
}