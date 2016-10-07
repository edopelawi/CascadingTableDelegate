//
//  TestableTableView.swift
//  CascadingTableDelegate
//
//  Created by Ice House on 10/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

/**
 
 This class is solely created to help testing `prepare(tableView:)` method for `CascadingTableDelegate`s.
 
 Sure, we could make `prepare(tableView:)` uses a new protocol instead of bare `UITableView`, and makes `UITableView` extends the new protocol... but it might confuse this library user further.
 */
class TestableTableView: UITableView {

    /// Records whether this instance's `reloadData` has been called or not.
    var reloadDataCalled = false
    
    convenience init() {
        self.init(frame: CGRectZero, style: .Plain)
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

    // MARK: - Test methods
    
    func resetRecordedParameters() {
        reloadDataCalled = false
    }
}
