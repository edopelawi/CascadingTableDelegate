//
//  PropagatingTableDelegateSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateSpec: QuickSpec {
	
	override func spec() {
		
		var propagatingTableDelegate: PropagatingTableDelegate!
		
		beforeEach { 
			propagatingTableDelegate = PropagatingTableDelegate(index: 100, childDelegates: [])
		}
		
		it("should store the passed index on its initializer") { 
			expect(propagatingTableDelegate.index).to(equal(100))
		}
	}
}
