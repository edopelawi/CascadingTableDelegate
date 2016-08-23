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
	Stores latest `UITableViewDataSource` or `UITableViewDelegate` method string signature that called as key, and the parameter as the value.
 
	It will store the parameters as tuple with original sequence as value, if the parameter is more than one.
	
	- note: Since this only store the latest call, it will only have one key and value.
	*/
	var latestCalledDelegateFunction = [String: Any]()
	
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
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		
		return UITableViewCell()
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		latestCalledDelegateFunction = [#function: tableView]
		
		return 0
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		return nil
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		
		return false
	}
	
	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		
		latestCalledDelegateFunction = [#function: tableView]
		
		return nil
	}
	
	func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
		
		latestCalledDelegateFunction = [#function: (tableView, title, index)]
		
		return 0
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, editingStyle, indexPath)]
	}
	
	
	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, sourceIndexPath, destinationIndexPath)]
	}
	
}

extension CascadingTableDelegateStub: UITableViewDelegate {
	
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

		latestCalledDelegateFunction = [#function: (tableView, cell, indexPath)]
	}
	
	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		latestCalledDelegateFunction = [#function: (tableView, view, section)]
	}
	
	func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		latestCalledDelegateFunction = [#function: (tableView, view, section)]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, cell, indexPath)]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		
		latestCalledDelegateFunction = [#function: (tableView, view, section)]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		
		latestCalledDelegateFunction = [#function: (tableView, view, section)]
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return CGFloat.min
	}
	
	
	func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		
		return CGFloat.min
	}
	
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		
		return nil
	}
	
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		latestCalledDelegateFunction = [#function: (tableView, section)]
		
		return nil
	}
	
	func tableView(tableView: UITableView, accessoryTypeForRowWithIndexPath indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return UITableViewCellAccessoryType.None
	}
	
	func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
	}
	
	
	func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		
		return false
	}
	
	func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		
	}
	
	func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
	}
	
	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return nil
	}
	
	func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return nil
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
	}
	
	func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		
		return UITableViewCellEditingStyle.None
	}
	
	func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]

		return nil
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return nil
	}
	
	func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return false
	}
	
	func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
	}
	
	func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {

		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
	}
	
	func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
		
		latestCalledDelegateFunction = [#function: (tableView, sourceIndexPath, proposedDestinationIndexPath)]
		
		return NSIndexPath(forRow: 0, inSection: 0)
	}
	
	func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return 0
	}
	
	func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return false
	}
	
	func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
		
		latestCalledDelegateFunction = [#function: (tableView, action, indexPath, sender)]
		return false
	}
	
	func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
		
		latestCalledDelegateFunction = [#function: (tableView, action, indexPath, sender)]
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		latestCalledDelegateFunction = [#function: (tableView, indexPath)]
		return false
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool {
		latestCalledDelegateFunction = [#function: (tableView, context)]
		return false
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		
		latestCalledDelegateFunction = [#function: (tableView, context, coordinator)]
	}
	
	@available(iOS 9.0, *)
	func indexPathForPreferredFocusedViewInTableView(tableView: UITableView) -> NSIndexPath? {
		
		latestCalledDelegateFunction = [#function: tableView]
		return nil
	}
	
}


