//
//  PropagatingTableDelegateCopyPasteSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateCopyPasteSpec: QuickSpec {
	
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
        
		describe("tableView(_: shouldShowMenuForRowAtIndexPath:)", {
            
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .Row propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .Row
                })
                
                context("with invalid indexPath row value", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        let indexPath = NSIndexPath(forRow: 999, inSection: 0)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAtIndexPath: indexPath)
                    })
                    
                    it("shoul return false ", closure: {
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implement the corresponding method", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        let indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAtIndexPath: indexPath)
                    })
                    
                    it("should return false", closure: {
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the corresponding method", {
                    
                    var expectedResult: Bool!
                    var result: Bool!
                    
                    var indexPath: NSIndexPath!
                    
                    beforeEach({
                        
                        expectedResult = true
                        childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
                        
                        indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAtIndexPath: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAtIndexPath:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                            fail("tableView(_: shouldShowMenuForRowAtIndexPath:) not called properly")
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
                
                context("with invalid indexPath section value", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        let indexPath = NSIndexPath(forRow: 0, inSection: 999)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAtIndexPath: indexPath)
                    })
                    
                    it("shoul return false ", closure: {
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implement the corresponding method", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        let indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAtIndexPath: indexPath)
                    })
                    
                    it("should return false", closure: {
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its' child method", closure: {
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the corresponding method", {
                    
                    var expectedResult: Bool!
                    var result: Bool!
                    
                    var indexPath: NSIndexPath!
                    
                    beforeEach({
                        
                        expectedResult = true
                        childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
                        
                        indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAtIndexPath: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAtIndexPath:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                            fail("tableView(_: shouldShowMenuForRowAtIndexPath:) not called properly")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })

        })
        
//		pending("tableView(_: canPerformAction: forRowAtIndexPath: withSender:)", {})
//		pending("tableView(_: performAction: forRowAtIndexPath: withSender:)", {})
	}
}
