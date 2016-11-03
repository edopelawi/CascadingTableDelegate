//
//  PropagatingTableDelegateHeaderFooterSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateHeaderFooterSpec: QuickSpec {
	
	override func spec() {
		
		var propagatingTableDelegate: PropagatingTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		var tableView: UITableView!
		
		let bareChildDelegateIndex = 0
		let completeChildDelegateIndex = 1
		
		beforeEach {
			tableView = UITableView()
			
			childDelegates = [
				CascadingTableDelegateBareStub(index: bareChildDelegateIndex, childDelegates: []),
				CascadingTableDelegateCompleteStub(index: completeChildDelegateIndex, childDelegates: [])
			]
			
			propagatingTableDelegate = PropagatingTableDelegate(
				index: 0,
				childDelegates: childDelegates.map({ $0 as CascadingTableDelegate})
			)
		}
		
		describe("tableView(_:viewForHeaderInSection:)", {
			
			context("on .row propagation mode", {
				
				var result: UIView?
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
					
					result = propagatingTableDelegate.tableView(tableView, viewForHeaderInSection: 0)
				})
				
				it("should return nil", closure: { 
					expect(result).to(beNil())
				})
				
				it("should not call any of its child's method", closure: { 
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
			})
			
			context("on .section propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid section value", {
					
					var result: UIView?
					
					beforeEach({ 
						result = propagatingTableDelegate.tableView(tableView, viewForHeaderInSection: 999)
					})
					
					it("should return nil", closure: { 
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", { 
					
					var result: UIView?
					
					beforeEach({
						result = propagatingTableDelegate.tableView(tableView, viewForHeaderInSection: bareChildDelegateIndex)
					})
					
					it("should return nil", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", { 
					
					var expectedResult: UIView?
					var sectionIndex: Int!
					
					var result: UIView?
					
					beforeEach({ 
						sectionIndex = completeChildDelegateIndex
						expectedResult = UIView()
						
						childDelegates[sectionIndex].returnedViewOptional = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, viewForHeaderInSection: sectionIndex)
					})
					
					it("should return the child's method result", closure: {
						expect(result).to(beIdenticalTo(expectedResult))
					})
					
					it("should call child's corresponding method using the passed parameter", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))
						let latestMethods = childDelegates[sectionIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView(_:viewForHeaderInSection is not called correctly)")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.section).to(equal(completeChildDelegateIndex))
					})
					
				})
				
			})
		})
		
		describe("tableView(_:viewForFooterInSection:)", {

			context("on .row propagation mode", {
				
				var result: UIView?
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
					
					result = propagatingTableDelegate.tableView(tableView, viewForFooterInSection: 0)
				})
				
				it("should return nil", closure: {
					expect(result).to(beNil())
				})
				
				it("should not call any of its child's method", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
			})
			
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid section value", {
					
					var result: UIView?
					
					beforeEach({
						result = propagatingTableDelegate.tableView(tableView, viewForFooterInSection: 999)
					})
					
					it("should return nil", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement the method", {
					
					var result: UIView?
					
					beforeEach({
						result = propagatingTableDelegate.tableView(tableView, viewForFooterInSection: bareChildDelegateIndex)
					})
					
					it("should return nil", closure: {
						expect(result).to(beNil())
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child implements the method", {
					
					var expectedResult: UIView?
					var sectionIndex: Int!
					
					var result: UIView?
					
					beforeEach({
						sectionIndex = completeChildDelegateIndex
						expectedResult = UIView()
						
						childDelegates[sectionIndex].returnedViewOptional = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, viewForFooterInSection: sectionIndex)
					})
					
					it("should return the child's method result", closure: {
						expect(result).to(beIdenticalTo(expectedResult))
					})
					
					it("should call child's corresponding method using the passed parameter", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:))
						let latestMethods = childDelegates[sectionIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView(_:viewForFooterInSection is not called correctly)")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.section).to(equal(completeChildDelegateIndex))
					})
					
				})
				
			})
			
		})
	}
}
