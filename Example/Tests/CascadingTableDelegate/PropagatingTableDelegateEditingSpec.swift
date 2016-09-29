//
//  PropagatingTableDelegateEditingSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateEditingSpec: QuickSpec {

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
				
		describe("tableView(_: editingStyleForRowAtIndexPath:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .Row propagation mode", {
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Row
				})
				
				context("with invalid indexPath's row value", {
					
					var result: UITableViewCellEditingStyle!
					
					beforeEach({
						let indexPath = NSIndexPath(forRow: 999, inSection: 0)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
					})
					
					it("should return .None as result", closure: { 
						expect(result).to(equal(UITableViewCellEditingStyle.None))
					})
					
					it("should not call any of its child's methods", closure: { 
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
					
				})
				
				context("when corresponding child doesn't implement the method", { 
					
					var result: UITableViewCellEditingStyle!
					
					beforeEach({
						let indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
					})
					
					it("should return .None as result", closure: {
						expect(result).to(equal(UITableViewCellEditingStyle.None))
					})
					
					it("should not call any of its child's methods", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
					
				})
				
				context("when correspinding child implements the method", { 
					
					var expectedResult: UITableViewCellEditingStyle!
					var result: UITableViewCellEditingStyle!
					
					var indexPath: NSIndexPath!
					
					beforeEach({
						
						expectedResult = UITableViewCellEditingStyle.Insert
						
						childDelegates[completeChildDelegateIndex].returnedCellEditingStyle = expectedResult
						
						indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
						
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
						
					})
					
					it("should return the result of the corresponding child's method", closure: { 
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editingStyleForRowAtIndexPath:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: indexPath:) is not called correctly")
							return
						}
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
				
			})
			
			context("on .Section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .Section
				})
				
				context("with invalid indexPath's row value", {
					
					var result: UITableViewCellEditingStyle!
					
					beforeEach({
						let indexPath = NSIndexPath(forRow: 0, inSection: 999)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
					})
					
					it("should return .None as result", closure: {
						expect(result).to(equal(UITableViewCellEditingStyle.None))
					})
					
					it("should not call any of its child's methods", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
					
				})
				
				context("when corresponding child doesn't implement the method", {
					
					var result: UITableViewCellEditingStyle!
					
					beforeEach({
						let indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
					})
					
					it("should return .None as result", closure: {
						expect(result).to(equal(UITableViewCellEditingStyle.None))
					})
					
					it("should not call any of its child's methods", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
					
				})
				
				context("when correspinding child implements the method", {
					
					var expectedResult: UITableViewCellEditingStyle!
					var result: UITableViewCellEditingStyle!
					
					var indexPath: NSIndexPath!
					
					beforeEach({
						
						expectedResult = UITableViewCellEditingStyle.Insert
						
						childDelegates[completeChildDelegateIndex].returnedCellEditingStyle = expectedResult
						
						indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
						
					})
					
					it("should return the result of the corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editingStyleForRowAtIndexPath:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: indexPath:) is not called correctly")
							return
						}
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
				
			})
			
		})
		
		describe("tableView(_: titleForDeleteConfirmationButtonForRowAtIndexPath:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .Row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Row
				})
				
				context("with invalid indexPath row value", {
					
					var result: String?
					
					beforeEach({ 
						let indexPath = NSIndexPath(forRow: 999, inSection: 0)
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: { 
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", { 
					
					var result: String?
					
					beforeEach({ 
						let indexPath = NSIndexPath(
							forRow: bareChildDelegateIndex,
							inSection: 0
						)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", { 
					
					var expectedResult: String?
					var result: String?
					var indexPath: NSIndexPath!
					
					beforeEach({ 
						expectedResult = "Remove this"
						childDelegates[completeChildDelegateIndex].returnedStringOptional = expectedResult
						
						indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
					})
					
					it("should return the child's method result", closure: { 
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method with passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAtIndexPath:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: titleForDeleteConfirmationButtonForRowAtIndexPath:) not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
				})
			})
			
			context("on .Section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .Section
				})
				
				context("with invalid indexPath row value", {
					
					var result: String?
					
					beforeEach({
						let indexPath = NSIndexPath(forRow: 0, inSection: 999)
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					var result: String?
					
					beforeEach({
						let indexPath = NSIndexPath(
							forRow: 0,
							inSection: bareChildDelegateIndex
						)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", {
					
					var expectedResult: String?
					var result: String?
					var indexPath: NSIndexPath!
					
					beforeEach({
						expectedResult = "Remove this"
						childDelegates[completeChildDelegateIndex].returnedStringOptional = expectedResult
						
						indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
					})
					
					it("should return the child's method result", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method with passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAtIndexPath:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: titleForDeleteConfirmationButtonForRowAtIndexPath:) not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
				})
			})
		})
		
		describe("tableView(_: editActionsForRowAtIndexPath:)", {
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView()
			})
			
			context("on .Row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .Row
				})
				
				context("with invalid indexPath row value", {
					
					var result: [UITableViewRowAction]?
					
					beforeEach({
						
						let indexPath = NSIndexPath(forRow: 99, inSection: 0)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					var result: [UITableViewRowAction]?
					
					beforeEach({
						
						let indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", {
					
					var expectedResult: [UITableViewRowAction]?
					var result: [UITableViewRowAction]?
					var indexPath: NSIndexPath!
					
					beforeEach({
						expectedResult = [ UITableViewRowAction() ]
						childDelegates[completeChildDelegateIndex].returnedRowActions = expectedResult
						
						indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAtIndexPath: indexPath)
					})
					
					it("should return the result of corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editActionsForRowAtIndexPath:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: editActionsForRowAtIndexPath:) not called correctly.")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
						
					})
				})
			})
			
			context("on .Section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .Section
				})
				
				context("with invalid indexPath row value", {
					
					var result: [UITableViewRowAction]?
					
					beforeEach({
						
						let indexPath = NSIndexPath(forRow: 0, inSection: 99)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					var result: [UITableViewRowAction]?
					
					beforeEach({
						
						let indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAtIndexPath: indexPath)
					})
					
					it("should return nil as result", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", {
					
					var expectedResult: [UITableViewRowAction]?
					var result: [UITableViewRowAction]?
					var indexPath: NSIndexPath!
					
					beforeEach({
						expectedResult = [ UITableViewRowAction() ]
						childDelegates[completeChildDelegateIndex].returnedRowActions = expectedResult
						
						indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAtIndexPath: indexPath)
					})
					
					it("should return the result of corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editActionsForRowAtIndexPath:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: editActionsForRowAtIndexPath:) not called correctly.")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
						
					})
				})
			})
		})
//		
//		pending("tableView(_: shouldIndentWhileEditingRowAtIndexPath:)", {})
//		
//		pending("tableView(_: willBeginEditingRowAtIndexPath:)", {})
//		
//		pending("tableView(_: didEndEditingRowAtIndexPath:)", {})
	}
}
