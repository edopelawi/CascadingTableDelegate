//
//  PropagatingTableDelegateEditingSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
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
				
		describe("tableView(_:editingStyleForRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("with invalid indexPath's row value", {
					
					var result: UITableViewCellEditingStyle!
					
					beforeEach({
						let indexPath = IndexPath(row: 999, section: 0)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAt: indexPath)
					})
					
					it("should return .none as result", closure: { 
						expect(result).to(equal(UITableViewCellEditingStyle.none))
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
						let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAt: indexPath)
					})
					
					it("should return .none as result", closure: {
						expect(result).to(equal(UITableViewCellEditingStyle.none))
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
					
					var indexPath: IndexPath!
					
					beforeEach({
						
						expectedResult = UITableViewCellEditingStyle.insert
						
						childDelegates[completeChildDelegateIndex].returnedCellEditingStyle = expectedResult
						
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAt: indexPath)
						
					})
					
					it("should return the result of the corresponding child's method", closure: { 
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editingStyleForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:indexPath:) is not called correctly")
							return
						}
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
				
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid indexPath's section value", {
					
					var result: UITableViewCellEditingStyle!
					
					beforeEach({
						let indexPath = IndexPath(row: 0, section: 999)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAt: indexPath)
					})
					
					it("should return .none as result", closure: {
						expect(result).to(equal(UITableViewCellEditingStyle.none))
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
						let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAt: indexPath)
					})
					
					it("should return .none as result", closure: {
						expect(result).to(equal(UITableViewCellEditingStyle.none))
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
					
					var indexPath: IndexPath!
					
					beforeEach({
						
						expectedResult = UITableViewCellEditingStyle.insert
						
						childDelegates[completeChildDelegateIndex].returnedCellEditingStyle = expectedResult
						
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, editingStyleForRowAt: indexPath)
						
					})
					
					it("should return the result of the corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editingStyleForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:indexPath:) is not called correctly")
							return
						}
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
				
			})
			
		})
		
		describe("tableView(_:titleForDeleteConfirmationButtonForRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("with invalid indexPath row value", {
					
					var result: String?
					
					beforeEach({ 
						let indexPath = IndexPath(row: 999, section: 0)
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
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
						let indexPath = IndexPath(
							row: bareChildDelegateIndex,
							section: 0
						)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
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
					var indexPath: IndexPath!
					
					beforeEach({ 
						expectedResult = "Remove this"
						childDelegates[completeChildDelegateIndex].returnedStringOptional = expectedResult
						
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
					})
					
					it("should return the child's method result", closure: { 
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method with passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:titleForDeleteConfirmationButtonForRowAt:) not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid indexPath section value", {
					
					var result: String?
					
					beforeEach({
						let indexPath = IndexPath(row: 0, section: 999)
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
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
						let indexPath = IndexPath(
							row: 0,
							section: bareChildDelegateIndex
						)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
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
					var indexPath: IndexPath!
					
					beforeEach({
						expectedResult = "Remove this"
						childDelegates[completeChildDelegateIndex].returnedStringOptional = expectedResult
						
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
					})
					
					it("should return the child's method result", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method with passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:titleForDeleteConfirmationButtonForRowAt:) not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
				})
			})
		})
		
		describe("tableView(_:editActionsForRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("with invalid indexPath row value", {
					
					var result: [UITableViewRowAction]?
					
					beforeEach({
						
						let indexPath = IndexPath(row: 99, section: 0)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAt: indexPath)
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
						
						let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAt: indexPath)
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
					var indexPath: IndexPath!
					
					beforeEach({
						expectedResult = [ UITableViewRowAction() ]
						childDelegates[completeChildDelegateIndex].returnedRowActions = expectedResult
						
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAt: indexPath)
					})
					
					it("should return the result of corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editActionsForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:editActionsForRowAt:) not called correctly.")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
						
					})
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid indexPath section value", {
					
					var result: [UITableViewRowAction]?
					
					beforeEach({
						
						let indexPath = IndexPath(row: 0, section: 99)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAt: indexPath)
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
						
						let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAt: indexPath)
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
					var indexPath: IndexPath!
					
					beforeEach({
						expectedResult = [ UITableViewRowAction() ]
						childDelegates[completeChildDelegateIndex].returnedRowActions = expectedResult
						
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, editActionsForRowAt: indexPath)
					})
					
					it("should return the result of corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's method using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:editActionsForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:editActionsForRowAt:) not called correctly.")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
						
					})
				})
			})
		})
		
		describe("tableView(_:shouldIndentWhileEditingRowAt:)", {
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("when indexPath row has invalid value", { 
					
					var result: Bool!
					
					beforeEach({
						let indexPath = IndexPath(row: 99, section: 0)
						result = propagatingTableDelegate.tableView(tableView, shouldIndentWhileEditingRowAt: indexPath)
					})
					
					it("should return false as result", closure: { 
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child method", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					var result: Bool!
					
					beforeEach({
						let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						result = propagatingTableDelegate.tableView(tableView, shouldIndentWhileEditingRowAt: indexPath)
					})
					
					it("should return false as result", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child method", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("when corresponding child implements the method", {
					
					var expectedResult: Bool!
					var result: Bool!
					
					var indexPath: IndexPath!
					
					beforeEach({
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						result = propagatingTableDelegate.tableView(tableView, shouldIndentWhileEditingRowAt: indexPath)
					})
					
					it("should return child's method result", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call its' child method with the passed parameters", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:shouldIndentWhileEditingRowAt:) not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("when indexPath section has invalid value", {
					
					var result: Bool!
					
					beforeEach({
						let indexPath = IndexPath(row: 0, section: 99)
						result = propagatingTableDelegate.tableView(tableView, shouldIndentWhileEditingRowAt: indexPath)
					})
					
					it("should return false as result", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child method", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					var result: Bool!
					
					beforeEach({
						let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, shouldIndentWhileEditingRowAt: indexPath)
					})
					
					it("should return false as result", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child method", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("when corresponding child implements the method", {
					
					var expectedResult: Bool!
					var result: Bool!
					
					var indexPath: IndexPath!
					
					beforeEach({
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, shouldIndentWhileEditingRowAt: indexPath)
					})
					
					it("should return child's method result", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call its' child method with the passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:shouldIndentWhileEditingRowAt:) not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
			})
		})
		
		describe("tableView(_:willBeginEditingRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
				})
				
				it("should not call any of its child method for invalid indexPath row value", closure: {
					
					let indexPath = IndexPath(row: 999, section: 0)
					propagatingTableDelegate.tableView(tableView, willBeginEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its child method when corresponding child doesn't implement it", closure: {
					
					let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
					propagatingTableDelegate.tableView(tableView, willBeginEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method when the child implements it", closure: {
					
					let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
					propagatingTableDelegate.tableView(tableView, willBeginEditingRowAt: indexPath)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:willBeginEditingRowAt:))
					
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
						fail("tableView(_:willBeginEditingRowAtIndexPath)")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.indexPath).to(equal(indexPath))
				})
			})
			
			context("on .section propagation mode", { 
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				it("should not call any of its child method for invalid indexPath section value", closure: {
					
					let indexPath = IndexPath(row: 0, section: 999)
					propagatingTableDelegate.tableView(tableView, willBeginEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its child method when corresponding child doesn't implement it", closure: {
					
					let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
					propagatingTableDelegate.tableView(tableView, willBeginEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method when the child implements it", closure: {
					
					let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
					propagatingTableDelegate.tableView(tableView, willBeginEditingRowAt: indexPath)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:willBeginEditingRowAt:))
					
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
						fail("tableView(_:willBeginEditingRowAt:) not called correctly")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.indexPath).to(equal(indexPath))
				})
				
			})
		
		})

		describe("tableView(_:didEndEditingRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
				})
				
				it("should not call any of its child method for invalid indexPath row value", closure: {
					
					let indexPath = IndexPath(row: 999, section: 0)
					propagatingTableDelegate.tableView(tableView, didEndEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its child method when corresponding child doesn't implement it", closure: {
					
					let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
					propagatingTableDelegate.tableView(tableView, didEndEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method when the child implements it", closure: {
					
					let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
					propagatingTableDelegate.tableView(tableView, didEndEditingRowAt: indexPath)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:didEndEditingRowAt:))
					
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath?) else {
						fail("tableView(_:didEndEditingRowAt:) not called correctly")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.indexPath).to(equal(indexPath))
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				it("should not call any of its child method for invalid indexPath section value", closure: {
					
					let indexPath = IndexPath(row: 0, section: 999)
					propagatingTableDelegate.tableView(tableView, didEndEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its child method when corresponding child doesn't implement it", closure: {
					
					let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
					propagatingTableDelegate.tableView(tableView, didEndEditingRowAt: indexPath)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method when the child implements it", closure: {
					
					let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
					propagatingTableDelegate.tableView(tableView, didEndEditingRowAt: indexPath)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:didEndEditingRowAt:))
					
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as?  (tableView: UITableView, indexPath: IndexPath?) else {
						fail("tableView(_:didEndEditingRowAt:) not called correctly")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.indexPath).to(equal(indexPath))
				})
				
			})
			
		})
	}
}
