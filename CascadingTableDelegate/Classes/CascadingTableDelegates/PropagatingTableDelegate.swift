//
//  PropagatingTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//
//

import Foundation

class PropagatingTableDelegate: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
}
