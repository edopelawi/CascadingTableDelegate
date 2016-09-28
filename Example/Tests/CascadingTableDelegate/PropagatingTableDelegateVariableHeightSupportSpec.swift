//
//  PropagatingTableDelegateVariableHeightSupportSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateVariableHeightSupportSpec: QuickSpec {
	
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
			
			propagatingTableDelegate = PropagatingTableDelegate(index: 0, childDelegates: childDelegates.map({ $0 as CascadingTableDelegate}))
		}
		
		describe("tableView(_: heightForRowAtIndexPath:)", {

			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .Row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Row
				})
				
				context("on invalid indexPath row value", {
					
					var result: CGFloat!
					
					beforeEach({
						
						let indexPath = NSIndexPath(forRow: 999, inSection: 0)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAtIndexPath: indexPath
						)
					})
					
					it("should return CGFloat.min as the result", closure: { 
						expect(result).to(equal(CGFloat.min))
					})
					
					it("should not call any of its child method", closure: { 
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("on indexPath row value where corresponding child doesn't implement the method", {
					
					var result: CGFloat!
					
					beforeEach({ 
						let indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAtIndexPath: indexPath
						)
					})
					
					it("should return CGFloat.min as the result", closure: {
						expect(result).to(equal(CGFloat.min))
					})
					
					it("should not call any of its child method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("on indexPath row value where corresponding child implements the method", { 
					
					var expectedResult: CGFloat!
					
					var result: CGFloat!
					var indexPath: NSIndexPath!
					
					beforeEach({
						
						expectedResult = CGFloat(55)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAtIndexPath: indexPath
						)
					})
					
					it("should return the result of the corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's corresponding method using the passed parameters", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForRowAtIndexPath:))
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: heightForRowAtIndexPath:) is not called correctly")
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
				
				context("on invalid indexPath section value", {
					
					var result: CGFloat!
					
					beforeEach({
						
						let indexPath = NSIndexPath(forRow: 0, inSection: 999)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAtIndexPath: indexPath
						)
					})
					
					it("should return CGFloat.min as the result", closure: {
						expect(result).to(equal(CGFloat.min))
					})
					
					it("should not call any of its child method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("on indexPath row value where corresponding child doesn't implement the method", {
					
					var result: CGFloat!
					
					beforeEach({
						let indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAtIndexPath: indexPath
						)
					})
					
					it("should return CGFloat.min as the result", closure: {
						expect(result).to(equal(CGFloat.min))
					})
					
					it("should not call any of its child method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("on indexPath row value where corresponding child implements the method", {
					
					var expectedResult: CGFloat!
					
					var result: CGFloat!
					var indexPath: NSIndexPath!
					
					beforeEach({
						
						expectedResult = CGFloat(55)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAtIndexPath: indexPath
						)
					})
					
					it("should return the result of the corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's corresponding method using the passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForRowAtIndexPath:))
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
							fail("tableView(_: heightForRowAtIndexPath:) is not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
				
			})
		})
		
		describe("tableView(_: heightForHeaderInSection:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .Row propagation mode", { 
				
				var result: CGFloat!
				
				beforeEach({ 
					
					propagatingTableDelegate.propagationMode = .Row
					result = propagatingTableDelegate.tableView(tableView, heightForHeaderInSection: 0)
				})
				
				it("should not call any of its child methods on .Row propagation mode", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should return CGFloat.min as result", closure: { 
					expect(result).to(equal(CGFloat.min))
				})
			})
			
			context("on .Section propagation mode", { 
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .Section
				})
				
				context("with invalid section value", {
					
					var result: CGFloat!
					
					beforeEach({ 
						result = propagatingTableDelegate.tableView(tableView, heightForHeaderInSection: 999)
					})
					
					it("should return CGFloat.min as result", closure: { 
						expect(result).to(equal(CGFloat.min))
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
					
				})
				
				context("with section value where corresponding child doesn't implements it", { 
					
					var result: CGFloat!
					
					beforeEach({ 
						result = propagatingTableDelegate.tableView(tableView, heightForHeaderInSection: bareChildDelegateIndex)
					})
					
					it("should return CGFloat.min as result", closure: {
						expect(result).to(equal(CGFloat.min))
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with section value where corresponding child implements it", { 
					
					var expectedResult: CGFloat!
					
					var result: CGFloat!
					var sectionIndex: Int!
					
					beforeEach({ 
						expectedResult = CGFloat(999)
						
						sectionIndex = completeChildDelegateIndex
						childDelegates[sectionIndex].returnedFloat = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, heightForHeaderInSection: sectionIndex)
					})
					
					it("should return child's method result as result", closure: { 
						expect(result).to(equal(expectedResult))
					})
					
					it("should pass corresponding parameters to child's method", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))
						let latestMethods = childDelegates[sectionIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView_: heightForHeaderInSection is not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.section).to(equal(sectionIndex))
					})
					
				})
				
			})
			
		})
		
//
//		pending("tableView(_: heightForFooterInSection:)", {})
//		
//		pending("tableView(_: estimatedHeightForRowAtIndexPath:)", {})
//		
//		pending("tableView(_: estimatedHeightForHeaderInSection:)", {})
//		
//		pending("tableView(_: estimatedHeightForFooterInSection:)", {})
		
	}
}
