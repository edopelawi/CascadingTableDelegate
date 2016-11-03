//
//  UIView+RoundedCorner.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

extension UIView {
	
	/**
	Sets rounded corner to this instance with passed `radius`. If it's a nil, this will use **half of current frame's height**, which will result to smooth corner.
	
	- parameter radius: `CGFloat` optional.
	*/
	func setRoundedCorner(radius: CGFloat? = nil) {
		
		if let radius = radius {
			self.layer.cornerRadius = radius
		} else {
			self.layer.cornerRadius = self.frame.height / 2
		}
	}
}
