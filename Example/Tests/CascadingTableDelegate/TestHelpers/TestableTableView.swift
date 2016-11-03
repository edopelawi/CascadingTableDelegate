//
//  TestableTableView.swift
//  CascadingTableDelegate
//
//  Created by Ice House on 10/7/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

/**
 
 This class is solely created to help testing `prepare(tableView:)` method for `CascadingTableDelegate`s.
 
 Sure, we could make `prepare(tableView:)` uses a new protocol instead of bare `UITableView`, and makes `UITableView` extends the new protocol... but it might confuse this library user further.
 */
class TestableTableView: UITableView {

    /// Records whether this instance's `reloadData` has been called or not.
    var reloadDataCalled = false
	
	/// Records whether this instance's `reloadSections(_:withRowAnimation:)` has been called or not.
	var reloadSectionsCalled = false
	
	/// `NSIndexSet` that has been passed to the latest `reloadSections(_:withRowAnimation:)` call. Will be `nil` if it's not called yet.
	var passedReloadSectionsIndexSet: IndexSet?
	
	/// `UITableViewRowAnimation` that has been passed to the latest `reloadSections(_:withRowAnimation:)` call. Will be `nil` if it's not called yet.
	var passedReloadSectionsAnimation: UITableViewRowAnimation?
	
    convenience init() {
        self.init(frame: CGRect.zero, style: .plain)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// This method won't call its superclass' `reloadData`.
    override func reloadData() {
        reloadDataCalled = true
    }
	
	/// This method won't call its superclass' `reloadSections(_:withRowAnimation:)`
	override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
		reloadSectionsCalled = true
		
		passedReloadSectionsIndexSet = sections
		passedReloadSectionsAnimation = animation
	}

    // MARK: - Test methods
    
    func resetRecordedParameters() {
        reloadDataCalled = false
		reloadSectionsCalled = false
		
		passedReloadSectionsIndexSet = nil
		passedReloadSectionsAnimation = nil
    }
}
