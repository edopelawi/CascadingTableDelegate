//
//  PropagatingTableDelegateSelectorResponseSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
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
		
		describe("respondsToSelector(_:) for tableView(_:estimatedHeightForRowAtIndexPath:)") { 
			
			var selector: Selector!
			
			beforeEach({
				selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAtIndexPath:))
			})
			
			it("should return false if none of its child implements it", closure: { 
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateBareStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.respondsToSelector(selector)
				
				expect(result).to(beFalse())
			})
			
			it("should return true if any of its child implements it", closure: { 
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.respondsToSelector(selector)
				
				expect(result).to(beTrue())
			})
		}
		
		describe("respondsToSelector(_:) for tableView(_:estimatedHeightForHeaderInSection:)") {
			
			var selector: Selector!
			
			beforeEach({
				selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:))
			})
			
			it("should return false if none of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateBareStub(index: 0, childDelegates: [])
				]
				
				
				let result = propagatingTableDelegate.respondsToSelector(selector)
				
				expect(result).to(beFalse())
			})
			
			it("should return true if any of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.respondsToSelector(selector)
				
				expect(result).to(beTrue())
			})
		}
		
		describe("respondsToSelector(_:) for tableView(_:estimatedHeightForFooterInSection:)") {
			
			var selector: Selector!
			
			beforeEach({
				selector = #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:))
			})
			
			it("should return false if none of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateBareStub(index: 0, childDelegates: [])
				]
				
				
				let result = propagatingTableDelegate.respondsToSelector(selector)
				
				expect(result).to(beFalse())
			})
			
			it("should return true if any of its child implements it", closure: {
				
				propagatingTableDelegate.childDelegates = [
					CascadingTableDelegateBareStub(index: 0, childDelegates: []),
					CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
				]
				
				let result = propagatingTableDelegate.respondsToSelector(selector)
				
				expect(result).to(beTrue())
			})
		}
	}
}

