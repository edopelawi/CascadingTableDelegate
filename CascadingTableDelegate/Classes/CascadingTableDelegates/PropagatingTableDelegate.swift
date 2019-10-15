
//
//  PropagatingTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//
//

import Foundation

/** 
A `CascadingTableDelegate`-compliant class that propagates any `UITableViewDelegate` or `UITableViewDataSource` it received to its `childDelegates`, depending on its `propagationMode`.

- warning: This class implements optional `estimatedHeightFor...` methods, which will be propagated to all of its `childDelegates` if *any* of its child implements it.

	It is advised for the `childDelegates` to implement the `estimatedHeightFor...` methods, too. Should they not implement it, this class' instance will fall back to the normal `heightFor...` methods to prevent incorrect layouts.

- warning: Currently, this class doesn't implement:
 - `sectionIndexTitles(for:)`
 - `tableView(_:sectionForSectionIndexTitle:at:)`
 - `tableView(_:moveRowAt:to:)`
 - `tableView(_:shouldUpdateFocusIn:)`
 - `tableView(_:didUpdateFocusInContext:with:)`
 - `indexPathForPreferredFocusedView(in:)`
 - `tableView(_:targetIndexPathForMoveFromRowAt: toProposedIndexPath:)`

 since it's unclear how to propagate those methods to its childs.
*/
open class PropagatingTableDelegate: NSObject {
	
	public enum PropagationMode {
		
		/** 
		Uses `section` of passed `indexPath` on this instance methods to choose the index of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number of `childDelegates` as `UITableView`'s `numberOfSections`, and call the  `childDelegate` with matching index's `numberOfRowsInSection` when the corresponding method is called.
		*/
		case section
		
		/**
		Uses `row` of passed `indexPath` on this instance methods to choose the index of of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number `childDelegates` as `UITableView`'s `numberOfRowsInSection:`, and return undefined results for section-related method calls.
		*/
		case row
	}
	
	open var index: Int
	open var childDelegates: [CascadingTableDelegate] {
		didSet {
			validateChildDelegates()
		}
	}
	
	open weak var parentDelegate: CascadingTableDelegate?
	
    open var propagationMode: PropagationMode = .section
	
	convenience init(index: Int, childDelegates: [CascadingTableDelegate], propagationMode: PropagationMode) {
		
		self.init(index: index, childDelegates: childDelegates)
		self.propagationMode = propagationMode
	}
	
	public required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		
		self.index = index
		self.childDelegates = childDelegates
		
		super.init()
		
		validateChildDelegates()
	}
	
	// MARK: - Private methods 
	
	/**
	Returns corresponding `Int` for passed `indexPath`. Will return `nil` if passed `indexPath` is invalid.
	
	- parameter indexPath: `IndexPath` value.
	
	- returns: `Int` optional.
	*/
	fileprivate func getValidChildIndex(indexPath: IndexPath) -> Int? {
		
		let childIndex = (propagationMode == .row) ? (indexPath as IndexPath).row : (indexPath as IndexPath).section
		
		let isValidIndex = (childIndex >= 0) && (childIndex < childDelegates.count)
		
		return isValidIndex ? childIndex : nil
	}
	
	/**
	Returns `true` if passed `sectionIndex` and current `propagationMode` is allowed for section-related method call, and `false` otherwise.
	
	- parameter sectionIndex: `Int` representation of section index.
	
	- returns: `Bool` value.
	*/
	fileprivate func isSectionMethodAllowed(sectionIndex: Int) -> Bool {
		
		let validIndex = (sectionIndex >= 0) && (sectionIndex < childDelegates.count)
		
		return validIndex && (propagationMode == .section)
	}
	
	@objc open override func responds(to aSelector: Selector) -> Bool {
	
		// TODO: This method was implemented to prevent layout breaks caused by the `estimatedHeightFor...:` methods. Revisit this later whether it's still necessary or not.
		
		let specialSelectors: [Selector] = [
			#selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAt:)),
			#selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:)),
			#selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:))
		]
		
		guard specialSelectors.contains(aSelector), !childDelegates.isEmpty else {
			return super.responds(to: aSelector)
		}
		
		for delegate in childDelegates {
			
			if delegate.responds(to: aSelector) {
				return true
			}
		}
		
		return false
	}
}

extension PropagatingTableDelegate: CascadingTableDelegate {
	
	@objc open func prepare(tableView: UITableView) {
		
		childDelegates.forEach { delegate in
			delegate.prepare(tableView: tableView)
		}
		
	}
}

// MARK: - UITableViewDataSource

extension PropagatingTableDelegate: UITableViewDataSource {
	
	// MARK: - Mandatory methods
	
	@objc open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if propagationMode == .row {
			return childDelegates.count
		}
		
		for childDelegate in childDelegates {
			
			if childDelegate.index != section {
				continue
			}
			
			return childDelegate.tableView(tableView, numberOfRowsInSection: section)
		}
		
		return 0
	}
	
	@objc open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let validSectionMode = (propagationMode == .section) && ((indexPath as IndexPath).section < childDelegates.count)
		let validRowMode = (propagationMode == .row) && ((indexPath as IndexPath).row < childDelegates.count)
		
		if validSectionMode  {
			
			let indexSection = (indexPath as IndexPath).section
			return childDelegates[indexSection].tableView(tableView, cellForRowAt: indexPath)
		}
				
		if validRowMode {
			let indexRow = (indexPath as IndexPath).row
			return childDelegates[indexRow].tableView(tableView, cellForRowAt: indexPath)
		}
		
		return UITableViewCell()
	}
	
	// MARK: - Optional methods
	
	@objc open func numberOfSections(in tableView: UITableView) -> Int {
		return propagationMode == .section ? childDelegates.count : 0
	}
	
	@objc open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, titleForHeaderInSection: section)
	}
	
	@objc open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, titleForFooterInSection: section)
	}
	
	@objc open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return false
		}
		
		return childDelegates[childIndex].tableView?(tableView, canEditRowAt: indexPath) ?? false
	}
	
	@objc open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return false
		}
		
		return childDelegates[childIndex].tableView?(tableView, canMoveRowAt: indexPath) ?? false
	}
	
	@objc open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[childIndex].tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
	}
	
	// TODO: Revisit on how we should implement sectionIndex-related methods later.
	
}

// MARK: - UITableViewDelegate

extension PropagatingTableDelegate: UITableViewDelegate {
	
	
	// MARK: - Display Customization 
	
	@objc open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[childIndex].tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
	}
	
	@objc open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, willDisplayHeaderView: view, forSection: section)
	}
	
	@objc open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, willDisplayFooterView: view, forSection: section)
	}
	
	@objc open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[validIndex].tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
	}
	
	@objc open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
	}
	
	@objc open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
	}
	
	// MARK: - Height Support
	
	@objc open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
	
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return UITableView.automaticDimension
		}
		
		
		return childDelegates[validIndex].tableView?(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
	}
	
	@objc open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat(0)
		}
		
		return childDelegates[section].tableView?(tableView, heightForHeaderInSection: section) ?? CGFloat(0)
	}
	
	@objc open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat(0)
		}
		
		return childDelegates[section].tableView?(tableView, heightForFooterInSection: section) ?? CGFloat(0)
	}
	
	@objc open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return UITableView.automaticDimension
		}
		
		return childDelegates[validIndex].tableView?(tableView, estimatedHeightForRowAt: indexPath) ??
		childDelegates[validIndex].tableView?(tableView, heightForRowAt: indexPath) ??
		UITableView.automaticDimension
	}
	
	@objc open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat(0)
		}
		
		return childDelegates[section].tableView?(tableView, estimatedHeightForHeaderInSection: section) ??
			childDelegates[section].tableView?(tableView, heightForHeaderInSection: section) ??
			CGFloat(0)
	}
	
	@objc open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat(0)
		}
		
		return childDelegates[section].tableView?(tableView, estimatedHeightForFooterInSection: section) ??
			childDelegates[section].tableView?(tableView, heightForFooterInSection: section) ??
			CGFloat(0)
	}
	
	// MARK: - Header and Footer View
	
	@objc open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, viewForHeaderInSection: section)
	}
	
	@objc open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, viewForFooterInSection: section)
	}
	
	// MARK: - Editing
	
	@objc open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return .none
		}
		
		return childDelegates[validIndex].tableView?(tableView, editingStyleForRowAt: indexPath) ?? .none
	}
	
	@objc open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return nil
		}
		
		return childDelegates[validIndex].tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
	}
	
	@objc open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return nil
		}
		
		return childDelegates[validIndex].tableView?(tableView, editActionsForRowAt: indexPath)
	}
	
	@objc open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return false
		}
		
		return childDelegates[validIndex].tableView?(tableView, shouldIndentWhileEditingRowAt: indexPath) ?? false
	}
	
	@objc open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[validIndex].tableView?(tableView, willBeginEditingRowAt: indexPath)
	}
	
	@objc open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath!) else {
			return
		}
		
		childDelegates[validIndex].tableView?(tableView, didEndEditingRowAt: indexPath)
	}
    
    // MARK: - Selection
    
    @objc open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    @objc open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return true
        }
		
        return childDelegates[validIndex].tableView?(tableView, shouldHighlightRowAt: indexPath) ?? true
    }
    
    @objc open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    @objc open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    @objc open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return indexPath
        }
		
		let expectedSelector = #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))
		let expectedDelegate = childDelegates[validIndex]
		
		if expectedDelegate.responds(to: expectedSelector) {
			return expectedDelegate.tableView?(tableView, willSelectRowAt: indexPath)
		} else {
			return indexPath
		}
    }
    
    @objc open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return indexPath
        }
		
		let expectedSelector = #selector(UITableViewDelegate.tableView(_:willDeselectRowAt:))
		let expectedDelegate = childDelegates[validIndex]
		
		if expectedDelegate.responds(to: expectedSelector) {
			return expectedDelegate.tableView?(tableView, willDeselectRowAt: indexPath)
		} else {
			return indexPath
		}        
    }
    
    @objc open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    
    @objc open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didDeselectRowAt: indexPath)        
    }
    
    // MARK: - Copy & Paste
    
    
    @objc open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return false
        }
        
        return childDelegates[validIndex].tableView?(tableView, shouldShowMenuForRowAt: indexPath) ?? false
    }
    
    @objc open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return false
        }
        
        return childDelegates[validIndex].tableView?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender) ?? false
    }
    
    @objc open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)   
        
    }
    
    // MARK: - Focus
        
    @available(iOS 9.0, *)
    @objc open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return false
        }
        
        return childDelegates[validIndex].tableView?(tableView, canFocusRowAt: indexPath) ?? false
    }
    
    
    // MARK: - Reorder
    
    @objc open func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return 0
        }
        
        return childDelegates[validIndex].tableView?(tableView, indentationLevelForRowAt: indexPath) ?? 0
    }
}
