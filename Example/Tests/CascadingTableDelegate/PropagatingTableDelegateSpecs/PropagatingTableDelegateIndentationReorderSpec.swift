//
//  PropagatingTableDelegateIndentationReorderSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateIndentationReorderSpec: QuickSpec {
	
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
        
        describe("tableView(_:indentationLevelForRowAt:)", {
            
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .row propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .row
                })
                
                context("with invalid indexPath row value", {
                    
                    var result: Int!
                    
                    beforeEach({
						
                        let indexPath = IndexPath(row: 999, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, indentationLevelForRowAt: indexPath)
                    })
                    
                    it("shoul return zero ", closure: {
                        expect(result).to(equal(0))
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implement the corresponding method", {
                    
                    var result: Int!
                    
                    beforeEach({
                        let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, indentationLevelForRowAt: indexPath)
                    })
                    
                    it("should return zero", closure: {
                        expect(result).to(equal(0))
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the corresponding method", {
                    
                    var expectedResult: Int!
                    var result: Int!
                    
                    var indexPath: IndexPath!
                    
                    beforeEach({
                        
                        expectedResult = 5
                        childDelegates[completeChildDelegateIndex].returnedInt = expectedResult
                        
                        indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, indentationLevelForRowAt: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:indentationLevelForRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:indentationLevelForRowAt:) not called properly")
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
                    
                    var result: Int!
                    
                    beforeEach({
                        let indexPath = IndexPath(row: 0, section: 999)
                        result = propagatingTableDelegate.tableView(tableView, indentationLevelForRowAt: indexPath)
                    })
                    
                    it("shoul return zero ", closure: {
                        expect(result).to(equal(0))
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implement the corresponding method", {
                    
                    var result: Int!
                    
                    beforeEach({
                        let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, indentationLevelForRowAt: indexPath)
                    })
                    
                    it("should return zero", closure: {
                        expect(result).to(equal(0))
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the corresponding method", {
                    
                    var expectedResult: Int!
                    var result: Int!
                    
                    var indexPath: IndexPath!
                    
                    beforeEach({
                        
                        expectedResult = 5
                        childDelegates[completeChildDelegateIndex].returnedInt = expectedResult
                        
                        indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, indentationLevelForRowAt: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:indentationLevelForRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:indentationLevelForRowAt:) not called properly")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })

        })
        
        
//		pending("tableView(_:targetIndexPathForMoveFromRowAt: toProposedIndexPath:)", {})

	}
}
