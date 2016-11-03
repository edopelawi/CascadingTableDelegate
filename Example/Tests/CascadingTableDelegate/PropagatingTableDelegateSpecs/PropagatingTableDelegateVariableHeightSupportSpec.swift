//
//  PropagatingTableDelegateVariableHeightSupportSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateVariableHeightSupportSpec: QuickSpec {
	
	override func spec() {
		
		var propagatingTableDelegate: PropagatingTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		
		let bareChildDelegateIndex = 2
		let partialChildDelegateIndex = 1
		let completeChildDelegateIndex = 0
		
		beforeEach {
			childDelegates = [
				CascadingTableDelegateCompleteStub(index: completeChildDelegateIndex, childDelegates: []),CascadingTableDelegatePartialHeightStub(index: partialChildDelegateIndex, childDelegates: []),
                CascadingTableDelegateBareStub(index: bareChildDelegateIndex, childDelegates: [])
			]
			
			propagatingTableDelegate = PropagatingTableDelegate(index: 0, childDelegates: childDelegates.map({ $0 as CascadingTableDelegate}))
		}
		
		describe("tableView(_:heightForRowAt:)", {

			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("on invalid indexPath row value", {
					
					var result: CGFloat!
					
					beforeEach({
						
						let indexPath = IndexPath(row: 999, section: 0)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAt: indexPath
						)
					})
					
					it("should return UITableViewAutomaticDimension as the result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
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
						let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAt: indexPath
						)
					})
					
					it("should return UITableViewAutomaticDimension as the result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
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
					var indexPath: IndexPath!
					
					beforeEach({
						
						expectedResult = CGFloat(55)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAt: indexPath
						)
					})
					
					it("should return the result of the corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's corresponding method using the passed parameters", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:heightForRowAt:) is not called correctly")
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
				
				context("on invalid indexPath section value", {
					
					var result: CGFloat!
					
					beforeEach({
						
						let indexPath = IndexPath(row: 0, section: 999)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAt: indexPath
						)
					})
					
					it("should return UITableViewAutomaticDimension as the result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
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
						let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAt: indexPath
						)
					})
					
					it("should return UITableViewAutomaticDimension as the result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
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
					var indexPath: IndexPath!
					
					beforeEach({
						
						expectedResult = CGFloat(55)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(
							tableView,
							heightForRowAt: indexPath
						)
					})
					
					it("should return the result of the corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call the child's corresponding method using the passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:heightForRowAt:) is not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
				
			})
		})
		
		describe("tableView(_:heightForHeaderInSection:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				var result: CGFloat!
				
				beforeEach({ 
					
					propagatingTableDelegate.propagationMode = .row
					result = propagatingTableDelegate.tableView(tableView, heightForHeaderInSection: 0)
				})
				
				it("should not call any of its child methods on .row propagation mode", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should return 0 as result", closure: { 
					expect(result).to(equal(0))
				})
			})
			
			context("on .section propagation mode", { 
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid section value", {
					
					var result: CGFloat!
					
					beforeEach({ 
						result = propagatingTableDelegate.tableView(tableView, heightForHeaderInSection: 999)
					})
					
					it("should return 0 as result", closure: { 
						expect(result).to(equal(0))
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
					
					it("should return 0 as result", closure: {
						expect(result).to(equal(0))
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
		
		describe("tableView(_:heightForFooterInSection:)", {
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView()
			})
			
			context("on .row propagation mode", {
				
				var result: CGFloat!
				
				beforeEach({
					
					propagatingTableDelegate.propagationMode = .row
					result = propagatingTableDelegate.tableView(tableView, heightForFooterInSection: 0)
				})
				
				it("should not call any of its child methods on .row propagation mode", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
				
				it("should return 0 as result", closure: {
					expect(result).to(equal(0))
				})
			})
			
			context("on .section propagation mode", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("with invalid section value", {
					
					var result: CGFloat!
					
					beforeEach({
						result = propagatingTableDelegate.tableView(tableView, heightForFooterInSection: 999)
					})
					
					it("should return 0 as result", closure: {
						expect(result).to(equal(0))
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
						result = propagatingTableDelegate.tableView(tableView, heightForFooterInSection: bareChildDelegateIndex)
					})
					
					it("should return 0 as result", closure: {
						expect(result).to(equal(0))
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
						
						result = propagatingTableDelegate.tableView(tableView, heightForFooterInSection: sectionIndex)
					})
					
					it("should return child's method result as result", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should pass corresponding parameters to child's method", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))
						let latestMethods = childDelegates[sectionIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView_: heightForFooterInSection is not called correctly")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.section).to(equal(sectionIndex))
					})
					
				})
				
			})
		})
		
		describe("tableView(_:estimatedHeightForRowAt:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .row
				})
				
				context("where indexPath's row value is invalid", { 
					
					var result: CGFloat!
					
					beforeEach({ 
						
						let indexPath = IndexPath(row: 99, section: 0)
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should return UITableViewAutomaticDimension as result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where the corresponding child doesn't implement the method", {
					
					var result: CGFloat!
					
					beforeEach({ 
						let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should return UITableViewAutomaticDimension as result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where the corresponding child only implements tableView(_:heightForRowAt:)", {
					
					var expectedResult: CGFloat!
					var result: CGFloat!
					var indexPath: IndexPath!
					
					beforeEach({
						expectedResult = CGFloat(55)
						childDelegates[partialChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = IndexPath(row: partialChildDelegateIndex, section: 0)
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should call child's tableView(_:heightForRowAt:) and using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
						
						let latestMethods = childDelegates[partialChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {

							fail("tableView(_:estimatedHeightForRowAt:) doesn't fall back to tableView(_:heightForRowAt:)")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
					it("should return result of child's tableView(_:heightForRowAt:)", closure: { 
						expect(result).to(equal(expectedResult))
					})
				})
				
				context("where corresponding child implements the method", { 
					
					var expectedResult: CGFloat!
					
					var result: CGFloat!
					var indexPath: IndexPath!
					
					beforeEach({ 
					
						expectedResult = CGFloat(37)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should return the corresponding child's method result", closure: { 
						expect(result).to(equal(expectedResult))
					})
					
					it("should call corresponding child's method using passed parameters", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:estimatedHeightForRowAtIndexPath) not called properly.")
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
				
				context("where indexPath's section value is invalid", {
					
					var result: CGFloat!
					
					beforeEach({
						
						let indexPath = IndexPath(row: 0, section: 99)
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should return UITableViewAutomaticDimension as result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where the corresponding child doesn't implement the method", {
					
					var result: CGFloat!
					
					beforeEach({
						let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should return UITableViewAutomaticDimension as result", closure: {
						expect(result).to(equal(UITableViewAutomaticDimension))
					})
					
					it("should not call any of its child's method", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where the corresponding child only implements tableView(_:heightForRowAt:)", {
					
					var expectedResult: CGFloat!
					var result: CGFloat!
					var indexPath: IndexPath!
					
					beforeEach({
						expectedResult = CGFloat(55)
						childDelegates[partialChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = IndexPath(row: 0, section: partialChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should call child's tableView(_:heightForRowAt:) and using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
						
						let latestMethods = childDelegates[partialChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							
							fail("tableView(_:estimatedHeightForRowAt:) doesn't fall back to tableView(_:heightForRowAt:)")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
					it("should return result of child's tableView(_:heightForRowAt:)", closure: {
						expect(result).to(equal(expectedResult))
					})
				})
				
				context("where corresponding child implements the method", {
					
					var expectedResult: CGFloat!
					
					var result: CGFloat!
					var indexPath: IndexPath!
					
					beforeEach({
						
						expectedResult = CGFloat(37)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForRowAt: indexPath)
					})
					
					it("should return the corresponding child's method result", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call corresponding child's method using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAt:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
							fail("tableView(_:estimatedHeightForRowAtIndexPath) not called properly.")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
				})
			})
		})

		describe("tableView(_:estimatedHeightForHeaderInSection:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView()
			})
			
			context("on .row propagation method", { 
				
				var result: CGFloat!
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
					result = propagatingTableDelegate.tableView(tableView, estimatedHeightForHeaderInSection: 0)
				})
				
				it("should return 0", closure: { 
					expect(result).to(equal(0))
				})
				
				it("should not call any of its child delegate's methods", closure: { 
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation method", {
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("where invalid section", {
					
					var result: CGFloat!
					
					beforeEach({ 
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForHeaderInSection: 99)
					})
					
					it("should return 0", closure: { 
						expect(result).to(equal(0))
					})
					
					it("should not call any of its child's methods", closure: { 
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				
				context("where corresponding child doesn't implement it", { 
					
					var result: CGFloat!
					
					beforeEach({ 
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForHeaderInSection: bareChildDelegateIndex)
					})
					
					it("should return 0", closure: {
						expect(result).to(equal(0))
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where the corresponding child only implements tableView(_:heightForHeaderInSection:)", {
					
					var expectedResult: CGFloat!
					var result: CGFloat!
					
					beforeEach({
						expectedResult = CGFloat(55)
						childDelegates[partialChildDelegateIndex].returnedFloat = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForHeaderInSection: partialChildDelegateIndex)
					})
					
					it("should call child's tableView(_:heightForRowAt:) and using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))
						
						let latestMethods = childDelegates[partialChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {
							
							fail("tableView(_:estimatedHeightForHeaderInSection:) doesn't fall back to tableView(_:heightForHeaderInSection:)")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.section).to(equal(partialChildDelegateIndex))
					})
					
					it("should return result of child's tableView(_:heightForHeaderInSection:)", closure: {
						expect(result).to(equal(expectedResult))
					})
				})
				
				context("where corresponding child implements it", { 
					
					var expectedResult: CGFloat!
					var result: CGFloat!
					
					beforeEach({
						
						expectedResult = CGFloat(77)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForHeaderInSection: completeChildDelegateIndex)
					})
					
					it("should return corresponding child's method result", closure: { 
						
						expect(result).to(equal(expectedResult))
					})
					
					it("should call corresponding child's method with passed parameter", closure: { 
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameter = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {

							fail("tableView(_:estimatedHeightForHeaderInSection:) is not called correctly")
							return
						}
						
						expect(calledParameter.tableView).to(beIdenticalTo(tableView))
						expect(calledParameter.section).to(equal(completeChildDelegateIndex))
					})
				})
			})
		})

		describe("tableView(_:estimatedHeightForFooterInSection:)", {
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView()
			})
			
			context("on .row propagation method", {
				
				var result: CGFloat!
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .row
					result = propagatingTableDelegate.tableView(tableView, estimatedHeightForFooterInSection: 0)
				})
				
				it("should return 0", closure: {
					expect(result).to(equal(0))
				})
				
				it("should not call any of its child delegate's methods", closure: {
					for delegate in childDelegates {
						expect(delegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .section propagation method", {
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .section
				})
				
				context("where invalid section", {
					
					var result: CGFloat!
					
					beforeEach({
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForFooterInSection: 99)
					})
					
					it("should return 0", closure: {
						expect(result).to(equal(0))
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where corresponding child doesn't implement it", {
					
					var result: CGFloat!
					
					beforeEach({
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForFooterInSection: bareChildDelegateIndex)
					})
					
					it("should return 0", closure: {
						expect(result).to(equal(0))
					})
					
					it("should not call any of its child's methods", closure: {
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("where the corresponding child only implements tableView(_:heightForFooterInSection:)", {
					
					var expectedResult: CGFloat!
					var result: CGFloat!
					
					beforeEach({
						expectedResult = CGFloat(55)
						childDelegates[partialChildDelegateIndex].returnedFloat = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForFooterInSection: partialChildDelegateIndex)
					})
					
					it("should call child's tableView(_:heightForFooterInSection:) and using passed parameters", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))
						
						let latestMethods = childDelegates[partialChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {
							
							fail("tableView(_:estimatedHeightForFooterInSection:) doesn't fall back to tableView(_:heightForFooterInSection:)")
							return
						}
						
						expect(calledParameters.tableView).to(beIdenticalTo(tableView))
						expect(calledParameters.section).to(equal(partialChildDelegateIndex))
					})
					
					it("should return result of child's tableView(_:heightForFooterInSection:)", closure: {
						expect(result).to(equal(expectedResult))
					})
				})
				
				context("where corresponding child implements it", {
					
					var expectedResult: CGFloat!
					var result: CGFloat!
					
					beforeEach({
						
						expectedResult = CGFloat(77)
						
						childDelegates[completeChildDelegateIndex].returnedFloat = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, estimatedHeightForFooterInSection: completeChildDelegateIndex)
					})
					
					it("should return corresponding child's method result", closure: {
						
						expect(result).to(equal(expectedResult))
					})
					
					it("should call corresponding child's method with passed parameter", closure: {
						
						let expectedMethod = #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:))
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledParameter = latestMethods[expectedMethod] as? (tableView: UITableView, section: Int) else {
							
							fail("tableView(_:estimatedHeightForFooterInSection:) is not called correctly")
							return
						}
						
						expect(calledParameter.tableView).to(beIdenticalTo(tableView))
						expect(calledParameter.section).to(equal(completeChildDelegateIndex))
					})
				})
			})
			
		})
		
	}
}
