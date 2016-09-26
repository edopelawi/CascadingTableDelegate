//
//  PropagatingTableDelegateDelegationSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/23/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateDelegationSpec: QuickSpec {
	
	override func spec() {
		
		var propagatingTableDelegate: PropagatingTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		
		let bareChildDelegateIndex = 0
		let completeChildDelegateIndex = 1
		
		beforeEach {
			childDelegates = [
				CascadingTableDelegateBareStub(index: bareChildDelegateIndex, childDelegates: []),
				CascadingTableDelegateCompleteStub(index: completeChildDelegateIndex, childDelegates: [])
			]
			
			propagatingTableDelegate = PropagatingTableDelegate(
				index: 0,
				childDelegates: childDelegates.map({ $0 as CascadingTableDelegate })
			)
		}
		
		// Display customization
		
		describe("tableView(_: willDisplayCell: forRowAtIndexPath:)", {
			
			var tableView: UITableView!
			var tableCell: UITableViewCell!
			
			beforeEach({ 
				tableView = UITableView()
				tableCell = UITableViewCell()
			})
			
			context("on .Row propagation mode", {
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Row
				})
				
				context("with invalid indexPath row value", {
					
					beforeEach({ 
						
						let indexPath = NSIndexPath(forRow: 99, inSection: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplayCell: tableCell,
							forRowAtIndexPath: indexPath
						)
					})
					
					it("should not call any of its childs' method", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					beforeEach({ 
						let indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplayCell: tableCell,
							forRowAtIndexPath: indexPath
						)
					})
					
					it("should not call any of its child's method", closure: { 
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", { 
					
					var indexPath: NSIndexPath!
					
					beforeEach({ 
						indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplayCell: tableCell,
							forRowAtIndexPath: indexPath)
					})
					
					it("should call the child's method using the passed parameters", closure: { 
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters =  latestMethods[calledMethod] as? (tableView: UITableView, tableCell: UITableViewCell, indexPath: NSIndexPath) else {
								
								fail("tableView(_: willDIsplayCell: forRowAtIndexPath:) not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDisplayCell:forRowAtIndexPath:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.tableCell).to(beIdenticalTo(tableCell))
						expect(calledParameters.indexPath).to(equal(indexPath))
						
					})
				})
			})
			
			context("on .Section propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Section
				})
				
				context("with invalid indexPath section value ", { 
					
					beforeEach({
						let indexPath = NSIndexPath(forRow: 0, inSection: 99)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplayCell: tableCell,
							forRowAtIndexPath: indexPath
						)
					})
					
					it("should not call any of its child method", closure: { 
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					beforeEach({ 
						let indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplayCell: tableCell,
							forRowAtIndexPath: indexPath
						)
					})
					
					it("should not call any of its child methods", closure: { 
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponing child implements the method", { 
					
					var indexPath: NSIndexPath!
					
					beforeEach({ 
						indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplayCell: tableCell,
							forRowAtIndexPath: indexPath
						)
					})
					
					it("should call corresponding child's method with passed parameter", closure: { 
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, tableCell: UITableViewCell, indexPath: NSIndexPath) else {
								
								fail("tableView(_: willDisplayCell: forRowAtIndexpath:) is not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDisplayCell:forRowAtIndexPath:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.tableCell).to(beIdenticalTo(tableCell))
						expect(calledParameters.indexPath).to(beIdenticalTo(indexPath))
					})
				})
			})
		})
		
		pending("tableView(_: willDisplayHeaderView: forSection:)", {})
		
		pending("tableView(_: didEndDisplayingCell: forRowAtIndexPath:)", {})
		
		pending("tableView(_: didEndDisplayingFooterView: forSection:)", {})
		
		// Variable height support
		
		pending("tableView(_: heightForRowAtIndexPath:)", {})
		
		pending("tableView(_: heightForHeaderInSection:)", {})
		
		pending("tableView(_: heightForFooterInSection:)", {})
		
		pending("tableView(_: estimatedHeightForRowAtIndexPath:)", {})
		
		pending("tableView(_: estimatedHeightForHeaderInSection:)", {})
		
		pending("tableView(_: estimatedHeightForFooterInSection:)", {})
		
		// Section header and footer information
		
		pending("tableView(_: viewForHeaderInSection:)", {})
		
		pending("tableView(_: viewForFooterInSection:)", {})
		
		pending("tableView(_: accessoryButtonTappdForRowWithIndexPath:)", {})
		
		// Selection
		
		pending("tableView(_: shouldHighlightRowAtIndexPath:)", {})
		
		pending("tableView(_: didHighlightRowAtIndexPath:)", {})
		
		pending("tableView(_: didUnhighlightRowAtIndexPath:)", {})
		
		pending("tableView(_: willSelectRowAtIndexPath:)", {})
		
		pending("tableView(_: willDeselectRowAtIndexPath:)", {})
		
		pending("tableView(_: didSelectRowAtIndexPath:)", {})
		
		pending("tableView(_: didDeselectRowAtIndexPath:)", {})
		
		// Editing
		
		pending("tableView(_: editingStyleForRowAtIndexPath:)", {})
		
		pending("tableView(_: titleForDeleteConfirmationButtonForRowAtIndexPath:)", {})
		
		pending("tableView(_: editActionsForRowAtIndePath:)", {})
		
		pending("tableView(_: shouldIndentWhileEditingRowAtIndexPath:)", {})
		
		pending("tableView(_: willBeginEditingRowAtIndexPath:)", {})
		
		pending("tableView(_: didEndEditingRowAtIndexPath:)", {})
		
		// Moving/reordering
		
		pending("tableView(_: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath:)", {})
		
		// Indentation
		
		pending("tableView(_: indentationLevelForRowAtIndexPath:)", {})
		
		// Copy / Paste
		pending("tableView(_: shouldShowMenuForRowAtIndexPath:)", {})
		pending("tableView(_: canPerformAction: forRowAtIndexPath: withSender:)", {})
		pending("tableView(_: performAction: forRowAtIndexPath: withSender:)", {})
		
		// Focus
		pending("tableView(_: canFocusRowAtIndexPath:)", {})
		pending("tableView(_: shouldUpdateFocusInContext)", {})
		pending("tableView(_: didUpdateFocusInContext: withAnimationCoordinator:)", {})
		pending("indexPathForPreferredFocusedViewInTableView(_:)", {})
	}
}