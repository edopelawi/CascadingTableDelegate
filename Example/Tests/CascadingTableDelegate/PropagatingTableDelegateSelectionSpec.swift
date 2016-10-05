//
//  PropagatingTableDelegateSelectionSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateSelectionSpec: QuickSpec {
	
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
        
		describe("tableView(_: accessoryButtonTappedForRowWithIndexPath:)", {
            
            var tableView: UITableView!
            
            beforeEach({ 
                tableView = UITableView()
            })
            
            context("on .Row propagation mode", { 
                
                beforeEach({ 
                    propagatingTableDelegate.propagationMode = .Row
                })
                
                it("should not call any of its child's method on invalid indexPath row value", closure: { 
                    
                    let indexPath = NSIndexPath(forRow: 999, inSection: 0)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: { 
                    
                    let indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: { 
                    
                    
                    let indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWithIndexPath:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                        fail("tableView(_: accessoryButtonTappedForRowAtIndexPath:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
            
            context("on .Section propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .Section
                })
                
                it("should not call any of its child's method on invalid indexPath section value", closure: {
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: 999)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWithIndexPath:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                        fail("tableView(_: accessoryButtonTappedForRowAtIndexPath:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
        })
		
		describe("tableView(_: shouldHighlightRowAtIndexPath:)", {
            
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: { 
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAtIndexPath:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                            fail("tableView(_: shouldHighlightRowAtIndexPath:) not called properly")
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAtIndexPath:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                            fail("tableView(_: shouldHighlightRowAtIndexPath:) not called properly")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })
        })

		describe("tableView(_: didHighlightRowAtIndexPath:)", {
        
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .Row propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .Row
                })
                
                it("should not call any of its child's method on invalid indexPath row value", closure: {
                    
                    let indexPath = NSIndexPath(forRow: 999, inSection: 0)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAtIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAtIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAtIndexPath: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didHighlightRowAtIndexPath:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                        fail("tableView(_: didHighlightRowAtIndexPath:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
            
            context("on .Section propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .Section
                })
                
                it("should not call any of its child's method on invalid indexPath section value", closure: {
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: 999)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAtIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAtIndexPath: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAtIndexPath: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didHighlightRowAtIndexPath:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
                        fail("tableView(_: didHighlightRowAtIndexPath:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
        })
		
		pending("tableView(_: didUnhighlightRowAtIndexPath:)", {})
//		
//		pending("tableView(_: willSelectRowAtIndexPath:)", {})
//		
//		pending("tableView(_: willDeselectRowAtIndexPath:)", {})
//		
//		pending("tableView(_: didSelectRowAtIndexPath:)", {})
//		
//		pending("tableView(_: didDeselectRowAtIndexPath:)", {})
	}
	
}
