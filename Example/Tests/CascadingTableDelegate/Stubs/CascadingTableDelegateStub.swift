//
//  CascadingTableDelegateStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

@testable import CascadingTableDelegate

class CascadingTableDelegateStub: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	
	var prepareCalled = false
	var passedTableViewOnPrepare: UITableView?
	
	/**
	Stores latest `UITableViewDataSource` or `UITableViewDelegate` method `selector` that called as key, and the parameter as the value.
 
	It will store the parameters as tuple with original sequence as value, if the parameter is more than one.
	
	- note: Since this only store the latest call, it will only have one key and value.
	*/
	var latestCalledDelegateFunction = [Selector: Any]()
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
	func resetRecordedParameters() {
		
		prepareCalled = false
		passedTableViewOnPrepare = nil
		latestCalledDelegateFunction = [:]
	}
}

extension CascadingTableDelegateStub: CascadingTableDelegate {
	
	func prepare(tableView tableView: UITableView) {
		prepareCalled = true
		passedTableViewOnPrepare = tableView
	}
}

extension CascadingTableDelegateStub: UITableViewDataSource {

	// TODO: Update these implementations to facilitate tests later.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let selector = #selector(UITableViewDataSource.tableView(_:cellForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return UITableViewCell()
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		let selector = #selector(UITableViewDataSource.numberOfSectionsInTableView(_:))
		
		latestCalledDelegateFunction = [ selector: tableView ]
		
		return 0
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		let selector = #selector(UITableViewDataSource.tableView(_:titleForHeaderInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return nil
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDataSource.tableView(_:canMoveRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return false
	}
	
	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		
		let selector = #selector(UITableViewDataSource.sectionIndexTitlesForTableView(_:))
		
		latestCalledDelegateFunction = [ selector: tableView ]
		
		return nil
	}
	
	func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:sectionForSectionIndexTitle:atIndex:))
		
		latestCalledDelegateFunction = [ selector: (tableView, title, index) ]
		
		return 0
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDataSource.tableView(_:commitEditingStyle:forRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, editingStyle, indexPath) ]
	}
	
	
	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDataSource.tableView(_:moveRowAtIndexPath:toIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, sourceIndexPath, destinationIndexPath) ]
	}
	
}

extension CascadingTableDelegateStub: UITableViewDelegate {
	
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayCell:forRowAtIndexPath:))

		latestCalledDelegateFunction = [ selector: (tableView, cell, indexPath) ]
	}
	
	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayFooterView:forSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingCell:forRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, cell, indexPath) ]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return CGFloat.min
	}
	
	
	func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return CGFloat.min
	}
	
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return nil
	}
	
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:))
		
		latestCalledDelegateFunction = [ selector: (tableView, section) ]
		
		return nil
	}

	
	func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWithIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath)  ]
	}
	
	
	func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return false
	}
	
	func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didHighlightRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
	}
	
	func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willSelectRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return nil
	}
	
	func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDeselectRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return nil
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didDeselectRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didDeselectRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		
		let selector = #selector(UITableViewDelegate.tableView(_:editingStyleForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return UITableViewCellEditingStyle.None
	}
	
	func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]

		return nil
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:editActionsForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return nil
	}
	
	func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return false
	}
	
	func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willBeginEditingRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndEditingRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
	}
	
	func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
		
		let selector = #selector(UITableViewDelegate.tableView(_:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, sourceIndexPath, proposedDestinationIndexPath) ]
		
		return NSIndexPath(forRow: 0, inSection: 0)
	}
	
	func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
		
		let selector = #selector(UITableViewDelegate.tableView(_:indentationLevelForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return 0
	}
	
	func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return false
	}
	
	func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAtIndexPath:withSender:))
		
		latestCalledDelegateFunction = [ selector: (tableView, action, indexPath, sender)]
		
		return false
	}
	
	func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAtIndexPath:withSender:))
		
		latestCalledDelegateFunction = [ selector: (tableView, action, indexPath, sender) ]
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:canFocusRowAtIndexPath:))
		
		latestCalledDelegateFunction = [ selector: (tableView, indexPath) ]
		
		return false
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldUpdateFocusInContext:))
		
		latestCalledDelegateFunction = [ selector: (tableView, context) ]
		
		return false
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didUpdateFocusInContext:withAnimationCoordinator:))
		
		latestCalledDelegateFunction = [ selector: (tableView, context, coordinator) ]
	}
	
	@available(iOS 9.0, *)
	func indexPathForPreferredFocusedViewInTableView(tableView: UITableView) -> NSIndexPath? {
		
		let selector = #selector(UITableViewDelegate.indexPathForPreferredFocusedViewInTableView(_:))
		
		latestCalledDelegateFunction = [ selector: tableView ]
		
		return nil
	}
	
}


