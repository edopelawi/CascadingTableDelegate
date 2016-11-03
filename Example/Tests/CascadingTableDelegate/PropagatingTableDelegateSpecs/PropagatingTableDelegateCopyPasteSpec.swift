//
//  PropagatingTableDelegateCopyPasteSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
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
        
		describe("tableView(_:shouldShowMenuForRowAt:)", {
            
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .row propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .row
                })
                
                context("with invalid indexPath row value", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        let indexPath = IndexPath(row: 999, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAt: indexPath)
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
                        let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAt: indexPath)
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
                    
                    var indexPath: IndexPath!
                    
                    beforeEach({
                        
                        expectedResult = true
                        childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
                        
                        indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAt: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:shouldShowMenuForRowAt:) not called properly")
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
                    
                    var result: Bool!
                    
                    beforeEach({
                        let indexPath = IndexPath(row: 0, section: 999)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAt: indexPath)
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
                        let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAt: indexPath)
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
                    
                    var indexPath: IndexPath!
                    
                    beforeEach({
                        
                        expectedResult = true
                        childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
                        
                        indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, shouldShowMenuForRowAt: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:shouldShowMenuForRowAt:) not called properly")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })

        })
        
		describe("tableView(_:canPerformAction:forRowAt:withSender:)", {
            
            var tableView: UITableView!
            
            beforeEach({ 
                tableView = UITableView()
            })
            
            context("on .row propagation mode", {
                
                beforeEach({ 
                    propagatingTableDelegate.propagationMode = .row
                })
                
                context("with invalid indexPath row value", { 
                    
                    var result: Bool!
                    
                    beforeEach({ 
                    
                        let indexPath = IndexPath(row: 999, section: 0)
                        
                        result = propagatingTableDelegate.tableView(
                            tableView,
                            canPerformAction: #selector(UIResponder.copy(_:)),
                            forRowAt: indexPath,
                            withSender: tableView
                        )
                    })
                    
                    it("should return false", closure: { 
                        
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its child method", closure: { 
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("when corresponding child doesn't implement it", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        
                        let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                        
                        result = propagatingTableDelegate.tableView(
                            tableView,
                            canPerformAction: #selector(UIResponder.copy(_:)),
                            forRowAt: indexPath,
                            withSender: tableView
                        )
                    })
                    
                    it("should return false", closure: {
                        
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its child method", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("when corresponding child implements it", {
                    
                    var expectedResult: Bool!
                    var action: Selector!
                    var sender: AnyObject?
                    var indexPath: IndexPath!
                    
                    var result: Bool!
                    
                    beforeEach({
                        
                        expectedResult = true
                        childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
                        
                        action = #selector(UIResponder.copy(_:))
                        sender = NSObject()
                        
                        indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                        
                        result = propagatingTableDelegate.tableView(
                            tableView,
                            canPerformAction: action,
                            forRowAt: indexPath,
                            withSender: sender
                        )
                    })
                    
                    
                    it("should return child method's result", closure: { 
                        
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call child's method using passed parameters", closure: { 
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, action: Selector, indexPath: IndexPath, sender: Any?) else {
                            fail("tableView(_:canPerformAction:forRowAt:withSender:) is not called correctly")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.action).to(equal(action))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                        expect(calledParameters.sender).to(beIdenticalTo(sender))
                    })
                })
                
            })
            
            context("on .section propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                context("with invalid indexPath row value", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        
                        let indexPath = IndexPath(row: 0, section: 999)
                        
                        result = propagatingTableDelegate.tableView(
                            tableView,
                            canPerformAction: #selector(UIResponder.copy(_:)),
                            forRowAt: indexPath,
                            withSender: tableView
                        )
                    })
                    
                    it("should return false", closure: {
                        
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its child method", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("when corresponding child doesn't implement it", {
                    
                    var result: Bool!
                    
                    beforeEach({
                        
                        let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                        
                        result = propagatingTableDelegate.tableView(
                            tableView,
                            canPerformAction: #selector(UIResponder.copy(_:)),
                            forRowAt: indexPath,
                            withSender: tableView
                        )
                    })
                    
                    it("should return false", closure: {
                        
                        expect(result).to(beFalse())
                    })
                    
                    it("should not call any of its child method", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("when corresponding child implements it", {
                    
                    var expectedResult: Bool!
                    var action: Selector!
                    var sender: AnyObject?
                    var indexPath: IndexPath!
                    
                    var result: Bool!
                    
                    beforeEach({
                        
                        expectedResult = true
                        childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
                        
                        action = #selector(UIResponder.copy(_:))
                        sender = NSObject()
                        
                        indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                        
                        result = propagatingTableDelegate.tableView(
                            tableView,
                            canPerformAction: action,
                            forRowAt: indexPath,
                            withSender: sender
                        )
                    })
                    
                    
                    it("should return child method's result", closure: {
                        
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call child's method using passed parameters", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, action: Selector, indexPath: IndexPath, sender: Any?) else {
                            fail("tableView(_:canPerformAction:forRowAt:withSender:) is not called correctly")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.action).to(equal(action))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                        expect(calledParameters.sender).to(beIdenticalTo(sender))
                    })
                })
                
            })
        })
        
		describe("tableView(_:performAction:forRowAt:withSender:)", {
            
            var tableView: UITableView!
            
            beforeEach({ 
                tableView = UITableView()
            })
            
            context("on .row propagation mode", { 
                
                var action: Selector!
                var sender: AnyObject?
                
                beforeEach({
                    
                    action = #selector(UIResponder.copy(_:))
                    sender = NSObject()
                    
                    propagatingTableDelegate.propagationMode = .row
                })
                
                it("should not call any of its child method for invalid indexPath row value", closure: { 
                    
                    let indexPath = IndexPath(row: 999, section: 0)
                    
                    propagatingTableDelegate.tableView(
                        tableView,
                        performAction: action,
                        forRowAt: indexPath,
                        withSender: sender
                    )
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child method when corresponding child doesn't implement it", closure: { 
                    
                    let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                    
                    propagatingTableDelegate.tableView(
                        tableView,
                        performAction: action,
                        forRowAt: indexPath,
                        withSender: sender
                    )
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call corresponding child's method with passed parameters if it implements the method", closure: { 
                    
                    let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                    
                    propagatingTableDelegate.tableView(
                        tableView,
                        performAction: action,
                        forRowAt: indexPath,
                        withSender: sender
                    )
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:performAction:forRowAt:withSender:))
                    
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, action: Selector, indexPath: IndexPath, sender: Any?) else {
                        
                        fail("tableView(_:performAction:forRowAt:withSender:) not called correctly")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.action).to(equal(action))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                    expect(calledParameters.sender).to(beIdenticalTo(sender))
                })
            })
            
            
        })
	}
}
