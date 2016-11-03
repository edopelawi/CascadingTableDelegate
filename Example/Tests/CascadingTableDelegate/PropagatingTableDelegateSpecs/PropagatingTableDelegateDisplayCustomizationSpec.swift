//
//  PropagatingTableDelegateDisplayCustomizationSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate


class PropagatingTableDelegateDisplayCustomizationSpec: QuickSpec {
	
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
		
		describe("tableView(_:willDisplay:forRowAt:)", {
			
			var tableView: UITableView!
			var tableCell: UITableViewCell!
			
			beforeEach({
				tableView = UITableView()
				tableCell = UITableViewCell()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("with invalid indexPath row value", {
					
					beforeEach({
						
						let indexPath = IndexPath(row: 99, section: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplay: tableCell,
							forRowAt: indexPath
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
						let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplay: tableCell,
							forRowAt: indexPath
						)
					})
					
					it("should not call any of its child's method", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", {
					
					var indexPath: IndexPath!
					
					beforeEach({
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplay: tableCell,
							forRowAt: indexPath)
					})
					
					it("should call the child's method using the passed parameters", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters =  latestMethods[calledMethod] as? (tableView: UITableView, tableCell: UITableViewCell, indexPath: IndexPath) else {
								
								fail("tableView(_:willDisplay:forRowAt:) not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.tableCell).to(beIdenticalTo(tableCell))
						expect(calledParameters.indexPath).to(equal(indexPath))
						
					})
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid indexPath section value ", {
					
					beforeEach({
						let indexPath = IndexPath(row: 0, section: 99)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplay: tableCell,
							forRowAt: indexPath
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
						let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplay: tableCell,
							forRowAt: indexPath
						)
					})
					
					it("should not call any of its child methods", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponing child implements the method", {
					
					var indexPath: IndexPath!
					
					beforeEach({
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						propagatingTableDelegate.tableView(
							tableView,
							willDisplay: tableCell,
							forRowAt: indexPath
						)
					})
					
					it("should call corresponding child's method with passed parameter", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, tableCell: UITableViewCell, indexPath: IndexPath) else {
								
								fail("tableView(_:willDisplay:forRowAt:) is not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.tableCell).to(beIdenticalTo(tableCell))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
			})
		})
		
		describe("tableView(_:willDisplayHeaderView:forSection:)", {
			
			var tableView: UITableView!
			var headerView: UIView!
			
			beforeEach({ 
				tableView = UITableView()
				headerView = UIView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayHeaderView: headerView,
						forSection: 0
					)
				})
				
				it("should not call any of its child method", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .section
				})
				
				it("should not call any of its method for invalid section number", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayHeaderView: headerView,
						forSection: 999
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its method if corresponding child doesn't implement it", closure: { 
					
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayHeaderView: headerView,
						forSection: bareChildDelegateIndex
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method with the passed parameters if it implements the method", closure: { 
					
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayHeaderView: headerView,
						forSection: completeChildDelegateIndex
					)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:))
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, headerView: UIView, section: Int) else {
						fail("tableView(_:willDisplayHeaderView:forSection:) is not called correctly.")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.headerView).to(beIdenticalTo(headerView))
					expect(calledParameters.section).to(equal(completeChildDelegateIndex))
				})
			})
		
		})
		
		describe("tableView(_:willDisplayFooterView:forSection:)", {
		
			var tableView: UITableView!
			var footerView: UIView!
			
			beforeEach({
				tableView = UITableView()
				footerView = UIView()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayFooterView: footerView,
						forSection: 0
					)
				})
				
				it("should not call any of its child method", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				it("should not call any of its method for invalid section number", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayFooterView: footerView,
						forSection: 999
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its method if corresponding child doesn't implement it", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayFooterView: footerView,
						forSection: bareChildDelegateIndex
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method with the passed parameters if it implements the method", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						willDisplayFooterView: footerView,
						forSection: completeChildDelegateIndex
					)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDisplayFooterView:forSection:))
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, footerView: UIView, section: Int) else {
						fail("tableView(_:willDisplayFooterView:forSection:) is not called correctly.")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.footerView).to(beIdenticalTo(footerView))
					expect(calledParameters.section).to(equal(completeChildDelegateIndex))
				})
			})
		})

		describe("tableView(_:didEndDisplaying:forRowAt:)", {
			
			var tableView: UITableView!
			var tableCell: UITableViewCell!
			
			beforeEach({
				tableView = UITableView()
				tableCell = UITableViewCell()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("with invalid indexPath row value", {
					
					beforeEach({
						
						let indexPath = IndexPath(row: 99, section: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							didEndDisplaying: tableCell,
							forRowAt: indexPath
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
						
						let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							didEndDisplaying: tableCell,
							forRowAt: indexPath
						)
					})
					
					it("should not call any of its child's method", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", {
					
					var indexPath: IndexPath!
					
					beforeEach({
						
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						propagatingTableDelegate.tableView(
							tableView,
							didEndDisplaying: tableCell,
							forRowAt: indexPath)
					})
					
					it("should call the child's method using the passed parameters", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters =  latestMethods[calledMethod] as? (tableView: UITableView, tableCell: UITableViewCell, indexPath: IndexPath) else {
								
								fail("tableView(_:didEndDisplaying:forRowAt:) not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.tableCell).to(beIdenticalTo(tableCell))
						expect(calledParameters.indexPath).to(equal(indexPath))
						
					})
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid indexPath section value ", {
					
					beforeEach({
						let indexPath = IndexPath(row: 0, section: 99)
						
						propagatingTableDelegate.tableView(
							tableView,
							didEndDisplaying: tableCell,
							forRowAt: indexPath
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
						let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						
						propagatingTableDelegate.tableView(
							tableView,
							didEndDisplaying: tableCell,
							forRowAt: indexPath
						)
					})
					
					it("should not call any of its child methods", closure: {
						
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponing child implements the method", {
					
					var indexPath: IndexPath!
					
					beforeEach({
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						propagatingTableDelegate.tableView(
							tableView,
							didEndDisplaying: tableCell,
							forRowAt: indexPath
						)
					})
					
					it("should call corresponding child's method with passed parameter", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, tableCell: UITableViewCell, indexPath: IndexPath) else {
								
								fail("tableView(_:didEndDisplaying:forRowAt:) is not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.tableCell).to(beIdenticalTo(tableCell))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
			})
		})
		
		describe("tableView(_:didEndDisplayingHeaderView:forSection:)", {
			
			var tableView: UITableView!
			var headerView: UIView!
			
			beforeEach({
				tableView = UITableView()
				headerView = UIView()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingHeaderView: headerView,
						forSection: 0
					)
				})
				
				it("should not call any of its child method", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				it("should not call any of its child method for invalid section number", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingHeaderView: headerView,
						forSection: 999
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its method if corresponding child doesn't implement it", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingHeaderView: headerView,
						forSection: bareChildDelegateIndex
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method with the passed parameters if it implements the method", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingHeaderView: headerView,
						forSection: completeChildDelegateIndex
					)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:))
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, headerView: UIView, section: Int) else {
						fail("tableView(_:didEndDisplayingHeaderView:forSection:) is not called correctly.")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.headerView).to(beIdenticalTo(headerView))
					expect(calledParameters.section).to(equal(completeChildDelegateIndex))
				})
			})
		})

		describe("tableView(_:didEndDisplayingFooterView:forSection:)", {
			var tableView: UITableView!
			var footerView: UIView!
			
			beforeEach({
				tableView = UITableView()
				footerView = UIView()
			})
			
			context("on .row propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingFooterView: footerView,
						forSection: 0
					)
				})
				
				it("should not call any of its child method", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				it("should not call any of its method for invalid section number", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingFooterView: footerView,
						forSection: 999
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should not call any of its method if corresponding child doesn't implement it", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingFooterView: footerView,
						forSection: bareChildDelegateIndex
					)
					
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should call its corresponding child method with the passed parameters if it implements the method", closure: {
					
					propagatingTableDelegate.tableView(
						tableView,
						didEndDisplayingFooterView: footerView,
						forSection: completeChildDelegateIndex
					)
					
					let expectedMethod = #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:))
					let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, footerView: UIView, section: Int) else {
						fail("tableView(_:didEndDisplayingFooterView:forSection:) is not called correctly.")
						return
					}
					
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.footerView).to(beIdenticalTo(footerView))
					expect(calledParameters.section).to(equal(completeChildDelegateIndex))
				})
			})
		})
	}
}
