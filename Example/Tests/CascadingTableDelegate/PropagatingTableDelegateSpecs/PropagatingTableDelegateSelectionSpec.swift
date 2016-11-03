//
//  PropagatingTableDelegateSelectionSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
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
        
		describe("tableView(_:accessoryButtonTappedForRowWith:)", {
            
            var tableView: UITableView!
            
            beforeEach({ 
                tableView = UITableView()
            })
            
            context("on .row propagation mode", { 
                
                beforeEach({ 
                    propagatingTableDelegate.propagationMode = .row
                })
                
                it("should not call any of its child's method on invalid indexPath row value", closure: { 
                    
                    let indexPath = IndexPath(row: 999, section: 0)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: { 
                    
                    let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: { 
                    
                    
                    let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        fail("tableView(_:accessoryButtonTappedForRowAt:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
            
            context("on .section propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                it("should not call any of its child's method on invalid indexPath section value", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: 999)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        fail("tableView(_:accessoryButtonTappedForRowAt:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
        })
		
		describe("tableView(_:shouldHighlightRowAt:)", {
            
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAt: indexPath)
                    })
                    
                    it("shoul return true ", closure: {
                        expect(result).to(beTrue())
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAt: indexPath)
                    })
                    
                    it("should return true", closure: {
                        expect(result).to(beTrue())
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAt: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: { 
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:shouldHighlightRowAt:) not called properly")
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAt: indexPath)
                    })
                    
                    it("shoul return true ", closure: {
                        expect(result).to(beTrue())
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAt: indexPath)
                    })
                    
                    it("should return true", closure: {
                        expect(result).to(beTrue())
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
                        result = propagatingTableDelegate.tableView(tableView, shouldHighlightRowAt: indexPath)
                    })
                    
                    
                    it("should return the child method's result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call the child's method using passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:shouldHighlightRowAt:) not called properly")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })
        })

		describe("tableView(_:didHighlightRowAt:)", {
        
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .row propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .row
                })
                
                it("should not call any of its child's method on invalid indexPath row value", closure: {
                    
                    let indexPath = IndexPath(row: 999, section: 0)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        fail("tableView(_:didHighlightRowAt:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
            
            context("on .section propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                it("should not call any of its child's method on invalid indexPath section value", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: 999)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didHighlightRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        fail("tableView(_:didHighlightRowAt:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
        })
		
		describe("tableView(_:didUnhighlightRowAt:)", {
            
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .row propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .row
                })
                
                it("should not call any of its child's method on invalid indexPath row value", closure: {
                    
                    let indexPath = IndexPath(row: 999, section: 0)
                    propagatingTableDelegate.tableView(tableView, didUnhighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didUnhighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didUnhighlightRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        fail("tableView(_:didHighlightRowAt:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
            
            context("on .section propagation mode", {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                it("should not call any of its child's method on invalid indexPath section value", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: 999)
                    propagatingTableDelegate.tableView(tableView, didUnhighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method where corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didUnhighlightRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call it's corresponding child method with passed parameters if the child implements it", closure: {
                    
                    
                    let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didUnhighlightRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:))
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        fail("tableView(_:didUnhighlightRowAt:) is not called correctly.")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
        })
		
        describe("tableView(_:willSelectRowAt:)", {
            
            var tableView: UITableView!
            
            beforeEach({ 
                tableView = UITableView()
            })
            
            context("on .row propagation mode", closure: { 
                
                beforeEach({ 
                    propagatingTableDelegate.propagationMode = .row
                })
                
                context("with invalid indexPath row value", closure: {
					
					var indexPath: IndexPath!
                    var result: IndexPath?
					
                    beforeEach({
                        indexPath = IndexPath(row: 999, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, willSelectRowAt: indexPath)
                    })
                    
                    it("should return the passed indexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child methods", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implements the method", closure: { 
					
					var indexPath: IndexPath!
                    var result: IndexPath?
                    
                    beforeEach({ 
                        indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, willSelectRowAt: indexPath)
                        
                    })
                    
                    it("should return the passed indexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child method", closure: { 
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the method", closure: { 
                    
                    var expectedResult: IndexPath?
                    var indexPath: IndexPath!
                    
                    var result: IndexPath?
                    
                    beforeEach({ 
                        indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                        
                        expectedResult = indexPath
                        childDelegates[completeChildDelegateIndex].returnedIndexPathOptional = expectedResult
                        
                        result = propagatingTableDelegate.tableView(tableView, willSelectRowAt: indexPath)
                    })
                    
                    it("should return child's method result", closure: { 
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call child's method with passed parameter", closure: { 
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:willSelectRowAt:) not called correctly.")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })
            
            context("on .section propagation mode", closure: {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                context("with invalid indexPath section value", closure: {
					
					var indexPath: IndexPath!
                    var result: IndexPath?
					
                    beforeEach({
                        indexPath = IndexPath(row: 0, section: 999)
                        result = propagatingTableDelegate.tableView(tableView, willSelectRowAt: indexPath)
                    })
                    
                    it("should return the passed indexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child methods", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implements the method", closure: {
					
					var indexPath: IndexPath!
                    var result: IndexPath?
					
                    beforeEach({
						
                        indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, willSelectRowAt: indexPath)
                    })
                    
                    it("should return the passed indexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child method", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the method", closure: {
                    
                    var expectedResult: IndexPath?
                    var indexPath: IndexPath!
                    
                    var result: IndexPath?
                    
                    beforeEach({
                        indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                        
                        expectedResult = indexPath
                        childDelegates[completeChildDelegateIndex].returnedIndexPathOptional = expectedResult
                        
                        result = propagatingTableDelegate.tableView(tableView, willSelectRowAt: indexPath)
                    })
                    
                    it("should return child's method result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call child's method with passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:willSelectRowAt:) not called correctly.")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })
        })

		describe("tableView(_:willDeselectRowAt:)", {
        
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .row propagation mode", closure: {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .row
                })
                
                context("with invalid indexPath row value", closure: {
                    
                    var result: IndexPath?
					var indexPath: IndexPath!
					
                    beforeEach({
                        indexPath = IndexPath(row: 999, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, willDeselectRowAt: indexPath)
                    })
                    
                    it("should return the passed indexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child methods", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implements the method", closure: {
                    
                    var result: IndexPath?
					var indexPath: IndexPath!
					
                    beforeEach({
                        indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                        result = propagatingTableDelegate.tableView(tableView, willDeselectRowAt: indexPath)
                        
                    })
                    
                    it("should return the passed indexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child method", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the method", closure: {
                    
                    var expectedResult: IndexPath?
                    var indexPath: IndexPath!
                    
                    var result: IndexPath?
                    
                    beforeEach({
                        indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                        
                        expectedResult = indexPath
                        childDelegates[completeChildDelegateIndex].returnedIndexPathOptional = expectedResult
                        
                        result = propagatingTableDelegate.tableView(tableView, willDeselectRowAt: indexPath)
                    })
                    
                    it("should return child's method result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call child's method with passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDeselectRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:willDeselectRowAt:) not called correctly.")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })
            
            context("on .section propagation mode", closure: {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                context("with invalid indexPath section value", closure: {
                    
                    var result: IndexPath?
					var indexPath: IndexPath!
					
                    beforeEach({
                        indexPath = IndexPath(row: 0, section: 999)
                        result = propagatingTableDelegate.tableView(tableView, willDeselectRowAt: indexPath)
                    })
                    
                    it("should return the passed IndexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child methods", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child doesn't implements the method", closure: {
                    
                    var result: IndexPath?
					var indexPath: IndexPath!
					
                    beforeEach({
                        indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                        result = propagatingTableDelegate.tableView(tableView, willDeselectRowAt: indexPath)
                        
                    })
                    
                    it("should return the passed indexPath", closure: {
                        expect(result).to(equal(indexPath))
                    })
                    
                    it("should not call any of its child method", closure: {
                        
                        for delegate in childDelegates {
                            expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                        }
                    })
                })
                
                context("where corresponding child implements the method", closure: {
                    
                    var expectedResult: IndexPath?
                    var indexPath: IndexPath!
                    
                    var result: IndexPath?
                    
                    beforeEach({
                        indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                        
                        expectedResult = indexPath
                        childDelegates[completeChildDelegateIndex].returnedIndexPathOptional = expectedResult
                        
                        result = propagatingTableDelegate.tableView(tableView, willDeselectRowAt: indexPath)
                    })
                    
                    it("should return child's method result", closure: {
                        expect(result).to(equal(expectedResult))
                    })
                    
                    it("should call child's method with passed parameter", closure: {
                        
                        let expectedMethod = #selector(UITableViewDelegate.tableView(_:willDeselectRowAt:))
                        
                        let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                        
                        guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                            fail("tableView(_:willDeselectRowAt:) not called correctly.")
                            return
                        }
                        
                        expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                        expect(calledParameters.indexPath).to(equal(indexPath))
                    })
                    
                })
            })
        })
		
        describe("tableView(_:didSelectRowAt:)", {
            
            var tableView: UITableView!
            
            beforeEach({ 
                tableView = UITableView()
            })
            
            context("on .row propagation mode", closure: { 
                
                beforeEach({ 
                    propagatingTableDelegate.propagationMode = .row
                })
                
                it("should not call any of its child's method for invalid indexPath row value", closure: { 
                    
                    let indexPath = IndexPath(row: 999, section: 0)
                    propagatingTableDelegate.tableView(tableView, didSelectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method when corresponding child doesn't implement it", closure: { 
                    
                    let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didSelectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call child's method with passed parameter when corresponding child implements it", closure: { 
                    
                    let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didSelectRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
                    
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {

                        fail("tableView(_:didSelectRowAt:) not called correctly")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
            
            context("on .section propagation mode", closure: {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                it("should not call any of its child's method for invalid indexPath section value", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: 999)
                    propagatingTableDelegate.tableView(tableView, didSelectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method when corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didSelectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call child's method with passed parameter when corresponding child implements it", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didSelectRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
                    
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        
                        fail("tableView(_:didSelectRowAt:) not called correctly")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
        })

		describe("tableView(_:didDeselectRowAt:)", {
        
            
            var tableView: UITableView!
            
            beforeEach({
                tableView = UITableView()
            })
            
            context("on .row propagation mode", closure: {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .row
                })
                
                it("should not call any of its child's method for invalid indexPath row value", closure: {
                    
                    let indexPath = IndexPath(row: 999, section: 0)
                    propagatingTableDelegate.tableView(tableView, didDeselectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method when corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: bareChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didDeselectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call child's method with passed parameter when corresponding child implements it", closure: {
                    
                    let indexPath = IndexPath(row: completeChildDelegateIndex, section: 0)
                    propagatingTableDelegate.tableView(tableView, didDeselectRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didDeselectRowAt:))
                    
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        
                        fail("tableView(_:didDeselectRowAt:) not called correctly")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
            
            context("on .section propagation mode", closure: {
                
                beforeEach({
                    propagatingTableDelegate.propagationMode = .section
                })
                
                it("should not call any of its child's method for invalid indexPath section value", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: 999)
                    propagatingTableDelegate.tableView(tableView, didDeselectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should not call any of its child's method when corresponding child doesn't implement it", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: bareChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didDeselectRowAt: indexPath)
                    
                    for delegate in childDelegates {
                        expect(delegate.latestCalledDelegateMethod).to(beEmpty())
                    }
                })
                
                it("should call child's method with passed parameter when corresponding child implements it", closure: {
                    
                    let indexPath = IndexPath(row: 0, section: completeChildDelegateIndex)
                    propagatingTableDelegate.tableView(tableView, didDeselectRowAt: indexPath)
                    
                    let expectedMethod = #selector(UITableViewDelegate.tableView(_:didDeselectRowAt:))
                    
                    let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
                    
                    guard let calledParameters = latestMethods[expectedMethod] as? (tableView: UITableView, indexPath: IndexPath) else {
                        
                        fail("tableView(_:didDeselectRowAt:) not called correctly")
                        return
                    }
                    
                    expect(calledParameters.tableView).to(beIdenticalTo(tableView))
                    expect(calledParameters.indexPath).to(equal(indexPath))
                })
            })
        })
	}
	
}
