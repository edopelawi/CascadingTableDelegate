//
//  PropagatingTableDelegateDataSourceOptionalSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble

@testable import CascadingTableDelegate

class CascadingTableDelegateDataSourceOptionalSpec: QuickSpec {
	
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
		
		describe("numberOfSections(in: _:)") { 
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			it("should return the number of child delegates in .section propagation mode", closure: {
				
				propagatingTableDelegate.propagationMode = .section
				
				let numberOfSections = propagatingTableDelegate.numberOfSections(in: tableView)
				
				expect(numberOfSections).to(equal(childDelegates.count))
			})
			
			it("should return 0 for .row propagation mode", closure: { 
				
				propagatingTableDelegate.propagationMode = .row
				
				let numberOfSections = propagatingTableDelegate.numberOfSections(in: tableView)
				
				expect(numberOfSections).to(equal(0))
			})
		}
		
		describe("tableView(_:titleForHeaderInSection:)") { 
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView()
			})
			
			it("should return nil for .row propagation mode", closure: { 
				
				propagatingTableDelegate.propagationMode = .row
				
				let sectionNumber = 0
				let headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				
				expect(headerTitle).to(beNil())
			})
			
			context("on .section propagation mode with invalid section number", { 
				
				var headerTitle: String?
				
				beforeEach({
					
					propagatingTableDelegate.propagationMode = .section
					
					let sectionNumber = 99
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return nil", closure: {
					expect(headerTitle).to(beNil())
				})
				
				it("should not call any of its child's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})

			})
			
			context("on .section propagation mode where the corresponding child  doesn't implement it", {
				
				var headerTitle: String?
				
				beforeEach({ 
				
					propagatingTableDelegate.propagationMode = .section
					
					let sectionNumber = bareChildDelegateIndex
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return nil", closure: {
					expect(headerTitle).to(beNil())
				})
				
				it("should not call any of its child's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation mode where the corresponding child implements it", { 
				
				var sectionNumber: Int!
				var expectedTitle: String?
				var headerTitle: String?
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .section
					
					sectionNumber = completeChildDelegateIndex
					
					expectedTitle = "Hello!"
					childDelegates[sectionNumber].returnedStringOptional = expectedTitle
					
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return result from the child's method", closure: {
					expect(headerTitle).to(equal(expectedTitle))
				})
				
				it("should call corresponding child delegate's method with passed parameter", closure: {
				
					let calledMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledMethod = calledMethods.keys.first,
						let calledParameters = calledMethods[calledMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView(_:titleForHeaderInSection:) not called correctly")
							return
					}
					
					
					expect(calledMethod).to(equal(#selector(UITableViewDataSource.tableView(_:titleForHeaderInSection:))))
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.section).to(equal(sectionNumber))
				})
			})
		}
		
		describe("tableView(_:titleForFooterInSection:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			it("should return nil for .row propagation mode", closure: { 
				
				propagatingTableDelegate.propagationMode = .row
				
				let sectionNumber = 0
				let footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				
				expect(footerTitle).to(beNil())
			})
			
			context("on .section propagation mode with invalid section number", { 
				
				var footerTitle: String?
				
				beforeEach({ 
					
					propagatingTableDelegate.propagationMode = .section
					
					let sectionNumber = 99
					footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				})
				
				it("should return nil", closure: { 
					expect(footerTitle).to(beNil())
				})
				
				it("should not call any of its child delegate's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation mode where the corresponding child doesn't implement it", {
				
				var footerTitle: String?
				
				beforeEach({ 
					
					propagatingTableDelegate.propagationMode = .section
					
					let sectionNumber = bareChildDelegateIndex
					footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				})
				
				it("should return nil", closure: { 
					expect(footerTitle).to(beNil())
				})
				
				it("should not call any of its child delegate's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation mode where the corresponding child implements it", { 
				
				var sectionNumber: Int!
				var expectedTitle: String?
				var footerTitle: String?
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
					
					sectionNumber = completeChildDelegateIndex
					expectedTitle = "Goodbye!"
					childDelegates[sectionNumber].returnedStringOptional = expectedTitle
					
					footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				})
				
				it("should return result from the child's method", closure: { 
					expect(footerTitle).to(equal(expectedTitle))
				})
				
				it("should call corresponding child delegate's method with passed parameter", closure: {
					
					let calledMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledMethod = calledMethods.keys.first,
						let calledParameters = calledMethods[calledMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView(_:titleForFooterInSection:) not called correctly")
							return
					}
					
					expect(calledMethod).to(equal(#selector(UITableViewDataSource.tableView(_:titleForFooterInSection:))))
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.section).to(equal(sectionNumber))
				})
			})
			
		})
		
		describe("tableView(_:canEditRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("with invalid indexPath row value", {
					
					var invalidIndexPath: IndexPath!
					var result: Bool!
					
					beforeEach({ 
						invalidIndexPath = IndexPath(row: 99, section: 0)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAt: invalidIndexPath)
					})
					
					it("should return false", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for childDelegate in childDelegates {
							expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath row value where corresponding child doesn't implement it", {
					
					var indexPath: IndexPath!
					var result: Bool!
					
					beforeEach({ 
						indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAt: indexPath)
					})
					
					it("should return false", closure: { 
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for childDelegate in childDelegates {
							expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath row value where corresponding child implements it", { 
					
					var indexPath: IndexPath!
					
					var expectedResult: Bool!
					var result: Bool!
					
					beforeEach({ 
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, canEditRowAt: indexPath)
					})
					
					it("should return result from the corresponding childs' method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call corresponding child's method and pass the parameters", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let parameters = latestMethods[calledMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
								fail("tableView(_:canEditRowAtIndexPath) is not called properly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDataSource.tableView(_:canEditRowAt:))
						expect(calledMethod).to(equal(expectedMethod))
						expect(parameters.tableView).to(equal(tableView))
						expect(parameters.indexPath).to(equal(indexPath))
					})
				})
			})
			
			context("on .section propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid indexPath section value", { 
					
					var invalidIndexPath: IndexPath!
					var result: Bool!
					
					beforeEach({ 
						invalidIndexPath = IndexPath(row: 0, section: 99)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAt: invalidIndexPath)
					})
					
					it("should return false", closure: { 
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath section value where corresponding child doesn't implement it", {
					
					var indexPath: IndexPath!
					var result: Bool!
					
					beforeEach({ 
						indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAt: indexPath)
					})
					
					it("should return false", closure: { 
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath section value where corresonding child implements it", { 
					
					var indexPath: IndexPath!
					var expectedResult: Bool!
					var result: Bool!
					
					beforeEach({ 
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, canEditRowAt: indexPath)
					})
					
					it("should call corresponding child's method with passed parameter", closure: { 
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
								fail("tableView(_:canEditRowAtIndexPath) is not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDataSource.tableView(_:canEditRowAt:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(equal(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
					it("should return the result from corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
				})
			})
		})
		
		describe("tableView(_:canMoveRowAt:)", {
		
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("with invalid indexPath row value", {
					
					var invalidIndexPath: IndexPath!
					var result: Bool!
					
					beforeEach({
						invalidIndexPath = IndexPath(row: 99, section: 0)
						result = propagatingTableDelegate.tableView(tableView, canMoveRowAt: invalidIndexPath)
					})
					
					it("should return false", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: {
						for childDelegate in childDelegates {
							expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath row value where corresponding child doesn't implement it", {
					
					var indexPath: IndexPath!
					var result: Bool!
					
					beforeEach({
						indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						result = propagatingTableDelegate.tableView(tableView, canMoveRowAt: indexPath)
					})
					
					it("should return false", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: {
						for childDelegate in childDelegates {
							expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath row value where corresponding child implements it", {
					
					var indexPath: IndexPath!
					
					var expectedResult: Bool!
					var result: Bool!
					
					beforeEach({
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, canMoveRowAt: indexPath)
					})
					
					it("should return result from the corresponding childs' method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call corresponding child's method and pass the parameters", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let parameters = latestMethods[calledMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
								fail("tableView(_:canMoveRowAtIndexPath) is not called properly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDataSource.tableView(_:canMoveRowAt:))
						expect(calledMethod).to(equal(expectedMethod))
						expect(parameters.tableView).to(equal(tableView))
						expect(parameters.indexPath).to(equal(indexPath))
					})
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid indexPath section value", {
					
					var invalidIndexPath: IndexPath!
					var result: Bool!
					
					beforeEach({
						invalidIndexPath = IndexPath(row: 0, section: 99)
						result = propagatingTableDelegate.tableView(tableView, canMoveRowAt: invalidIndexPath)
					})
					
					it("should return false", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath section value where corresponding child doesn't implement it", {
					
					var indexPath: IndexPath!
					var result: Bool!
					
					beforeEach({
						indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAt: indexPath)
					})
					
					it("should return false", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath section value where corresonding child implements it", {
					
					var indexPath: IndexPath!
					var expectedResult: Bool!
					var result: Bool!
					
					beforeEach({
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, canMoveRowAt: indexPath)
					})
					
					it("should call corresponding child's method with passed parameter", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
								fail("tableView(_:canEditRowAtIndexPath) is not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDataSource.tableView(_:canMoveRowAt:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(equal(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
					it("should return the result from corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
				})
			})
		})
		
		describe("tableView(_:commit:forRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
				})
				
				it("should not call its child methods if the corresponding child doesn't implement it", closure: { 
					
					let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
					
					propagatingTableDelegate.tableView(
						tableView,
						commit: UITableViewCellEditingStyle.none,
						forRowAt: indexPath
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call the corresponding child's method with the parameters if the child implements it", closure: {
					
					let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
					
					propagatingTableDelegate.tableView(
						tableView,
						commit: UITableViewCellEditingStyle.none,
						forRowAt: indexPath
					)
					
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledMethod = latestMethods.keys.first,
						let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, editingStyle: UITableViewCellEditingStyle, indexPath: IndexPath) else {
							
							fail("tableView(_:editingStyle:indexPath:) is not called correctly")
							return
					}
					
					let expectedMethod = #selector(UITableViewDataSource.tableView(_:commit:forRowAt:))
					
					expect(calledMethod).to(equal(expectedMethod))
					
					expect(calledParameters.tableView).to(equal(tableView))
					expect(calledParameters.editingStyle).to(equal(UITableViewCellEditingStyle.none))
					expect(calledParameters.indexPath).to(equal(indexPath))
				})
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				it("should not call its child methods if the corresponding child doesn't implement it", closure: {
					
					let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
					
					propagatingTableDelegate.tableView(
						tableView,
						commit: UITableViewCellEditingStyle.none,
						forRowAt: indexPath
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call the corresponding child's method with the parameters if the child implements it", closure: {
					
					let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
					
					propagatingTableDelegate.tableView(
						tableView,
						commit: UITableViewCellEditingStyle.none,
						forRowAt: indexPath
					)
					
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledMethod = latestMethods.keys.first,
						let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, editingStyle: UITableViewCellEditingStyle, indexPath: IndexPath) else {
							
							fail("tableView(_:editingStyle:indexPath:) is not called correctly")
							return
					}
					
					let expectedMethod = #selector(UITableViewDataSource.tableView(_:commit:forRowAt:))
					
					expect(calledMethod).to(equal(expectedMethod))
					
					expect(calledParameters.tableView).to(equal(tableView))
					expect(calledParameters.editingStyle).to(equal(UITableViewCellEditingStyle.none))
					expect(calledParameters.indexPath).to(equal(indexPath))
				})
			})
			
		})
		
		
//		pending("sectionIndexTitles(for:)", {})
//		
//		pending("tableView(_:sectionForSectionIndexTitle:at:)", {})
//		
//		pending("tableView(_:moveRowAt:to:)", {})
		
	}
	
}
