//
//  PropagatingTableDelegateSelectorResponseSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/11/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateSelectorResponseSpec: QuickSpec {
	
	override func spec() {
		var propagatingTableDelegate: PropagatingTableDelegate!
		
		beforeEach({
			propagatingTableDelegate = PropagatingTableDelegate(index: 0, childDelegates: [])
		})
		
		describe("responds(to:) for tableView(_:estimatedHeightForRowAt:)") { 
			
			var selector: Selector!
			
			beforeEach({
				selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAt:))
			})
			
			it("should return true if it has no child, because it implements the method by default", closure: {
				
				propagatingTableDelegate.childDelegates = []
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beTrue())
			})
			
			it("should return false if none of its child implements it", closure: { 
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateBareStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beFalse())
			})
			
			it("should return true if any of its child implements it", closure: { 
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beTrue())
			})
		}
		
		describe("responds(to:_:) for tableView(_:estimatedHeightForHeaderInSection:)") {
			
			var selector: Selector!
			
			beforeEach({
				selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:))
			})
			
			it("should return true if it has no child, because it implements the method by default", closure: {
				
				propagatingTableDelegate.childDelegates = []
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beTrue())
			})
			
			it("should return false if none of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateBareStub(index: 0, childDelegates: [])
				]
				
				
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beFalse())
			})
			
			it("should return true if any of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beTrue())
			})
		}
		
		describe("responds(to:) for tableView(_:estimatedHeightForFooterInSection:)") {
			
			var selector: Selector!
			
			beforeEach({
				selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:))
			})
			
			it("should return true if it has no child, because it implements the method by default", closure: {
				
				propagatingTableDelegate.childDelegates = []
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beTrue())
			})
			
			it("should return false if none of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateBareStub(index: 0, childDelegates: [])
				]
				
				
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beFalse())
			})
			
			it("should return true if any of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.responds(to: selector)
				
				expect(result).to(beTrue())
			})
		}
	}
}

