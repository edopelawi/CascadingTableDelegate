//
//  CascadingTableDelegateCompleteStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

@testable import CascadingTableDelegate

/// `CascadingTableDelegate`-compliant class that implements all method of `UITableViewDelegate` and `UITableViewDataSource`.
class CascadingTableDelegateCompleteStub: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	private var _prepareCalled = false
	
	private var _passedTableViewOnPrepare: UITableView?
	
	private let _returnedTableCell = UITableViewCell()
	
	private var _latestCalledDelegateMethod = [Selector: Any]()
	
	var returnedTableCell: UITableViewCell = UITableViewCell()
	
	var returnedInt: Int = 0
	
	var returnedStringOptional: String? = nil
	
	var returnedStringArrayOptional: [String]? = nil
	
	var returnedBool: Bool = false
	
	var returnedFloat: CGFloat = CGFloat.min
	
	var returnedViewOptional: UIView? = nil
	
	var returnedIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
	
	var returnedIndexPathOptional: NSIndexPath? = nil
	
	var returnedCellEditingStyle: UITableViewCellEditingStyle = .None
	
	var returnedRowActions: [UITableViewRowAction]? = nil
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
}

// MARK: - CascadingTableDelegateStub

extension CascadingTableDelegateCompleteStub: CascadingTableDelegateStub {
	
	var prepareCalled: Bool {
		return _prepareCalled
	}
	
	var passedTableViewOnPrepare: UITableView? {
		return _passedTableViewOnPrepare
	}
	
	var latestCalledDelegateMethod: [Selector: Any] {
		return _latestCalledDelegateMethod
	}
	
	func prepare(tableView tableView: UITableView) {
		_prepareCalled = true
		_passedTableViewOnPrepare = tableView
	}
	
	func resetRecordedParameters() {
		
		_prepareCalled = false
		_passedTableViewOnPrepare = nil
		_latestCalledDelegateMethod = [:]
	}
}

// MARK: - UITableViewDataSource

extension CascadingTableDelegateCompleteStub: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedInt
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let selector = #selector(UITableViewDataSource.tableView(_:cellForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedTableCell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		let selector = #selector(UITableViewDataSource.numberOfSectionsInTableView(_:))
		
		_latestCalledDelegateMethod = [ selector: tableView ]
		
		return returnedInt
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		let selector = #selector(UITableViewDataSource.tableView(_:titleForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedStringOptional
	}
	
	func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		
		let selector = #selector(UITableViewDataSource.tableView(_:titleForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedStringOptional
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDataSource.tableView(_:canEditRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDataSource.tableView(_:canMoveRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		
		let selector = #selector(UITableViewDataSource.sectionIndexTitlesForTableView(_:))
		
		_latestCalledDelegateMethod = [ selector: tableView ]
		
		return returnedStringArrayOptional
	}
	
	func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:sectionForSectionIndexTitle:atIndex:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, title, index) ]
		
		return returnedInt
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDataSource.tableView(_:commitEditingStyle:forRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, editingStyle, indexPath) ]
	}
	
	
	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDataSource.tableView(_:moveRowAtIndexPath:toIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, sourceIndexPath, destinationIndexPath) ]
	}
	
}

// MARK: - UITableViewDelegate

extension CascadingTableDelegateCompleteStub: UITableViewDelegate {
	
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayCell:forRowAtIndexPath:))

		_latestCalledDelegateMethod = [ selector: (tableView, cell, indexPath) ]
	}
	
	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayFooterView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingCell:forRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, cell, indexPath) ]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedFloat
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedFloat
	}
	
	
	func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedViewOptional
	}
	
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedViewOptional
	}
	
	func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWithIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath)  ]
	}
	
	
	func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didHighlightRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
	}
	
	func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willSelectRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedIndexPathOptional
	}
	
	func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDeselectRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedIndexPathOptional
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didSelectRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didDeselectRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		
		let selector = #selector(UITableViewDelegate.tableView(_:editingStyleForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedCellEditingStyle
	}
	
	func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]

		return returnedStringOptional
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:editActionsForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedRowActions
	}
	
	func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willBeginEditingRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndEditingRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
	}
	
	func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
		
		let selector = #selector(UITableViewDelegate.tableView(_:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, sourceIndexPath, proposedDestinationIndexPath) ]
		
		return NSIndexPath(forRow: 0, inSection: 0)
	}
	
	func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
		
		let selector = #selector(UITableViewDelegate.tableView(_:indentationLevelForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedInt
	}
	
	func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAtIndexPath:withSender:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, action, indexPath, sender)]
		
		return returnedBool
	}
	
	func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:performAction:forRowAtIndexPath:withSender:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, action, indexPath, sender) ]
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:canFocusRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldUpdateFocusInContext:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, context) ]
		
		return returnedBool
	}
	
	@available(iOS 9.0, *)
	func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didUpdateFocusInContext:withAnimationCoordinator:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, context, coordinator) ]
	}
	
	@available(iOS 9.0, *)
	func indexPathForPreferredFocusedViewInTableView(tableView: UITableView) -> NSIndexPath? {
		
		let selector = #selector(UITableViewDelegate.indexPathForPreferredFocusedViewInTableView(_:))
		
		_latestCalledDelegateMethod = [ selector: tableView ]
		
		return returnedIndexPathOptional
	}
	
}


