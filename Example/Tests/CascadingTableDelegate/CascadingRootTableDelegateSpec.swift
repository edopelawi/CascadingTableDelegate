//
//  CascadingRootTableDelegateSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/7/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble

@testable import CascadingTableDelegate

class CascadingRootTableDelegateSpec: QuickSpec {
    
    override func spec() {
        
        var rootTableDelegate: CascadingRootTableDelegate!
        var childDelegates: [CascadingTableDelegateStub]!
        
        beforeEach { 
            
            childDelegates = [
                CascadingTableDelegateBareStub(index: 0, childDelegates: []),
                CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
            ]
            
            rootTableDelegate = CascadingRootTableDelegate(
                index: 0,
                childDelegates: childDelegates.map({ $0 as CascadingTableDelegate }),
                propagationMode: .row
            )
        }
        
        it("should have .section as its default propagationMode, even if the initializer requests .row") {
            
            let expectedMode = PropagatingTableDelegate.PropagationMode.section
            expect(rootTableDelegate.propagationMode).to(equal(expectedMode))
        }
        
        it("should have .section as its propagationMode, even it's being set to another value.") { 
            
            rootTableDelegate.propagationMode = .row
            
            let expectedMode = PropagatingTableDelegate.PropagationMode.section
            expect(rootTableDelegate.propagationMode).to(equal(expectedMode))
        }
        
        describe("prepare(tableView:)") {
            
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
                rootTableDelegate.prepare(tableView: tableView)
            })
            
            afterEach({
                
                childDelegates.forEach({ delegate in
                    delegate.resetRecordedParameters()
                })
            })
            
            it("should set itself as passed tableView's delegate and dataSource", closure: { 
                expect(tableView.delegate).to(beIdenticalTo(rootTableDelegate))
                expect(tableView.dataSource).to(beIdenticalTo(rootTableDelegate))
            })
            
            it("should call its childs' prepare(tableView:) too", closure: { 
                
                for delegate in childDelegates {
                    expect(delegate.prepareCalled).to(beTrue())
                }
            })
            
        }
		
		it("should sort out its child delegate's indexes again when its childDelegates is changed") {
			
			let newDelegate = CascadingTableDelegateBareStub(index: 0, childDelegates: [])
			rootTableDelegate.childDelegates.append(newDelegate)
			
			let expectedIndex = rootTableDelegate.childDelegates.count - 1
			let lastDelegateIndex = rootTableDelegate.childDelegates.last?.index
			expect(lastDelegateIndex).to(equal(expectedIndex))
		}
        
        describe("reloadOnChildDelegateChanged") { 
            
            var testableTableView: TestableTableView!
			
            beforeEach({
                testableTableView = TestableTableView()
                rootTableDelegate.prepare(tableView: testableTableView)
            })
            
            afterEach({ 
                rootTableDelegate.childDelegates = childDelegates.map({ $0 as CascadingTableDelegate })
                testableTableView.resetRecordedParameters()
            })
            
            it("should not call its tableView's `reloadData()` for `false` value when its child is changed", closure: {
                
                rootTableDelegate.reloadOnChildDelegatesChanged = false
                rootTableDelegate.childDelegates = []
                
                expect(testableTableView.reloadDataCalled).to(beFalse())
            })
            
            it("should call its tableView's `reloadData()` for `true` value when its child is changed", closure: { 
                
                rootTableDelegate.reloadOnChildDelegatesChanged = true
                rootTableDelegate.childDelegates = []
                
                expect(testableTableView.reloadDataCalled).to(beTrue())
                
            })
        }
    }
}
