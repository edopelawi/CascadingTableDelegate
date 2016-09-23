//
//  PropagatingTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//
//

import Foundation

/** 
	A `CascadingTableDelegate`-compliant class that propagates any `UITableViewDelegate` or `UITableViewDataSource` it received to its `childDelegates`, depending on its `propagationMode`.

	- warning: Currently, this class doesn't implement: 
		- `sectionIndexTitlesForTableView(_:)`, 
		- `tableView(_: sectionForSectionIndexTitle: atIndex:)`, and 
		- `tableView(_: moveRowAtIndexPath: toIndexPath:)`,

		since it's unclear how to propagate those methods to its childs.
*/
class PropagatingTableDelegate: NSObject {
	
	enum PropagationMode {
		
		/** 
		Uses `section` of passed `indexPath` on this instance methods to choose the index of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number of `childDelegates` as `UITableView`'s `numberOfSections`, and call the  `childDelegate` with matching index's `numberOfRowsInSection` when the corresponding method is called.
		*/
		case Section
		
		/**
		Uses `row` of passed `indexPath` on this instance methods to choose the index of of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number `childDelegates` as `UITableView`'s `numberOfRowsInSection:`, and return undefined results for section-related method calls.
		*/
		case Row
	}
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	var propagationMode: PropagationMode = .Section
	
	convenience init(index: Int, childDelegates: [CascadingTableDelegate], propagationMode: PropagationMode) {
		
		self.init(index: index, childDelegates: childDelegates)
		self.propagationMode = propagationMode
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		
		self.index = index
		self.childDelegates = childDelegates
		
		super.init()
		
		validateChildDelegateIndexes()
	}
	
	// MARK: - Private methods 
	
	private func getChildIndex(indexPath indexPath: NSIndexPath) -> Int {
		return (propagationMode == .Row) ? indexPath.row : indexPath.section
	}
}

extension PropagatingTableDelegate: CascadingTableDelegate {
	
	func prepare(tableView tableView: UITableView) {
		
		childDelegates.forEach { delegate in
			delegate.prepare(tableView: tableView)
		}
		
	}
}


extension PropagatingTableDelegate: UITableViewDataSource {
	
	// MARK: - Mandatory methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if propagationMode == .Row {
			return childDelegates.count
		}
		
		for childDelegate in childDelegates {
			
			if childDelegate.index != section {
				continue
			}
			
			return childDelegate.tableView(tableView, numberOfRowsInSection: section)
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let validSectionMode = (propagationMode == .Section) && (indexPath.section < childDelegates.count)
		let validRowMode = (propagationMode == .Row) && (indexPath.row < childDelegates.count)
		
		if validSectionMode  {
			
			let indexSection = indexPath.section
			return childDelegates[indexSection].tableView(tableView, cellForRowAtIndexPath: indexPath)
		}
				
		if validRowMode {
			let indexRow = indexPath.row
			return childDelegates[indexRow].tableView(tableView, cellForRowAtIndexPath: indexPath)
		}
		
		return UITableViewCell()
	}
	
	// MARK: - Optional methods
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return propagationMode == .Section ? childDelegates.count : 0
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		let invalidIndex = (section >= childDelegates.count)
		
		if propagationMode == .Row || invalidIndex {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, titleForHeaderInSection: section)
	}
	
	func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		
		let invalidIndex = (section >= childDelegates.count)
		
		if propagationMode == .Row || invalidIndex {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, titleForFooterInSection: section)
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let childIndex = getChildIndex(indexPath: indexPath)
		
		let invalidIndex = (childIndex >= childDelegates.count)
		
		if invalidIndex {
			return false
		}
		
		return childDelegates[childIndex].tableView?(tableView, canEditRowAtIndexPath: indexPath) ?? false
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let childIndex = getChildIndex(indexPath: indexPath)
		
		let invalidIndex = (childIndex >= childDelegates.count)
		
		if invalidIndex {
			return false
		}
		
		return childDelegates[childIndex].tableView?(tableView, canMoveRowAtIndexPath: indexPath) ?? false
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let childIndex = getChildIndex(indexPath: indexPath)
		
		let invalidIndex = (childIndex >= childDelegates.count)
		
		if invalidIndex {
			return
		}
		
		childDelegates[childIndex].tableView?(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
	}
	
	// TODO: Revisit on how we should implement sectionIndex-related methods later.
	
}