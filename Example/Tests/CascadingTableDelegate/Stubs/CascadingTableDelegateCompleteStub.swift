//
//  CascadingTableDelegateCompleteStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

@testable import CascadingTableDelegate

/// `CascadingTableDelegate`-compliant class that implements all method of `UITableViewDelegate` and `UITableViewDataSource`.
class CascadingTableDelegateCompleteStub: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	fileprivate var _prepareCalled = false
	
	fileprivate var _passedTableViewOnPrepare: UITableView?
	
	fileprivate let _returnedTableCell = UITableViewCell()
	
	fileprivate var _latestCalledDelegateMethod = [Selector: Any]()
	
	var returnedTableCell: UITableViewCell = UITableViewCell()
	
	var returnedInt: Int = 0
	
	var returnedStringOptional: String? = nil
	
	var returnedStringArrayOptional: [String]? = nil
	
	var returnedBool: Bool = false
	
	var returnedFloat: CGFloat = CGFloat(1.1)
	
	var returnedViewOptional: UIView? = nil
	
	var returnedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
	
	var returnedIndexPathOptional: IndexPath? = nil
	
	var returnedCellEditingStyle: UITableViewCellEditingStyle = .none
	
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
	
	func prepare(tableView: UITableView) {
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedInt
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let selector = #selector(UITableViewDataSource.self.tableView(_:cellForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedTableCell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		let selector = #selector(UITableViewDataSource.numberOfSections(in:))
		
		_latestCalledDelegateMethod = [ selector: tableView ]
		
		return returnedInt
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		let selector = #selector(UITableViewDataSource.tableView(_:titleForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedStringOptional
	}
	
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		
		let selector = #selector(UITableViewDataSource.tableView(_:titleForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedStringOptional
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		let selector = #selector(UITableViewDataSource.tableView(_:canEditRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		
		let selector = #selector(UITableViewDataSource.tableView(_:canMoveRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		
		let selector = #selector(UITableViewDataSource.sectionIndexTitles(for:))
		
		_latestCalledDelegateMethod = [ selector: tableView ]
		
		return returnedStringArrayOptional
	}
	
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:sectionForSectionIndexTitle:at:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, title, index) ]
		
		return returnedInt
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDataSource.tableView(_:commit:forRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, editingStyle, indexPath) ]
	}
	
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		
		let selector = #selector(UITableViewDataSource.tableView(_:moveRowAt:to:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, sourceIndexPath, destinationIndexPath) ]
	}
	
}

// MARK: - UITableViewDelegate

extension CascadingTableDelegateCompleteStub: UITableViewDelegate {
	
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))

		_latestCalledDelegateMethod = [ selector: (tableView, cell, indexPath) ]
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDisplayFooterView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, cell, indexPath) ]
	}
	
	func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, view, section) ]
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedFloat
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedFloat
	}
	
	
	func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedViewOptional
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedViewOptional
	}
	
	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath)  ]
	}
	
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
	}
	
	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedIndexPathOptional
	}
	
	func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willDeselectRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedIndexPathOptional
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didDeselectRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		
		let selector = #selector(UITableViewDelegate.tableView(_:editingStyleForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedCellEditingStyle
	}
	
	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]

		return returnedStringOptional
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let selector = #selector(UITableViewDelegate.tableView(_:editActionsForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedRowActions
	}
	
	func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:willBeginEditingRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
	}
	
	func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didEndEditingRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
	}
	
	func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		
		let selector = #selector(UITableViewDelegate.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, sourceIndexPath, proposedDestinationIndexPath) ]
		
		return IndexPath(row: 0, section: 0)
	}
	
	func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
		
		let selector = #selector(UITableViewDelegate.tableView(_:indentationLevelForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedInt
	}
	
	func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, action, indexPath, sender)]
		
		return returnedBool
	}
	
	func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:performAction:forRowAt:withSender:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, action, indexPath, sender) ]
	}
	
	@available(iOS 9.0, *)
	func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:canFocusRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedBool
	}
	
	@available(iOS 9.0, *)
	func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
		
		let selector = #selector(UITableViewDelegate.tableView(_:shouldUpdateFocusIn:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, context) ]
		
		return returnedBool
	}
	
	@available(iOS 9.0, *)
	func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		
		let selector = #selector(UITableViewDelegate.tableView(_:didUpdateFocusIn:with:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, context, coordinator) ]
	}
	
	@available(iOS 9.0, *)
	func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
		
		let selector = #selector(UITableViewDelegate.indexPathForPreferredFocusedView(in:))
		
		_latestCalledDelegateMethod = [ selector: tableView ]
		
		return returnedIndexPathOptional
	}
	
}


