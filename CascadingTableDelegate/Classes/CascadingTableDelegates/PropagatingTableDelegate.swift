
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

	- warning: Currently, this class doesn't implement: 
		- `sectionIndexTitlesForTableView(_:)`, 
		- `tableView(_: sectionForSectionIndexTitle: atIndex:)`, and 
		- `tableView(_: moveRowAtIndexPath: toIndexPath:)`,

		since it's unclear how to propagate those methods to its childs.
*/
class PropagatingTableDelegate: NSObject {
	
	enum PropagationMode {
		
		/** 
		Uses `section` of passed `indexPath` on this instance methods to choose the index of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number of `childDelegates` as `UITableView`'s `numberOfSections`, and call the  `childDelegate` with matching index's `numberOfRowsInSection` when the corresponding method is called.
		*/
		case Section
		
		/**
		Uses `row` of passed `indexPath` on this instance methods to choose the index of of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number `childDelegates` as `UITableView`'s `numberOfRowsInSection:`, and return undefined results for section-related method calls.
		*/
		case Row
	}
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	var propagationMode: PropagationMode = .Section
	
	convenience init(index: Int, childDelegates: [CascadingTableDelegate], propagationMode: PropagationMode) {
		
		self.init(index: index, childDelegates: childDelegates)
		self.propagationMode = propagationMode
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		
		self.index = index
		self.childDelegates = childDelegates
		
		super.init()
		
		validateChildDelegateIndexes()
	}
	
	// MARK: - Private methods 
	
	/**
	Returns corresponding `Int` for passed `indexPath`. Will return `nil` if passed `indexPath` is invalid.
	
	- parameter indexPath: `NSIndexPath` value.
	
	- returns: `Int` optional.
	*/
	private func getValidChildIndex(indexPath indexPath: NSIndexPath) -> Int? {
		
		let childIndex = (propagationMode == .Row) ? indexPath.row : indexPath.section
		
		let isValidIndex = (childIndex < childDelegates.count)
		
		return isValidIndex ? childIndex : nil
	}
	
	/**
	Returns `true` if passed `sectionIndex` and current `propagationMode` is allowed for section-related method call, and `false` otherwise.
	
	- parameter sectionIndex: `Int` representation of section index.
	
	- returns: `Bool` value.
	*/
	private func isSectionMethodAllowed(sectionIndex sectionIndex: Int) -> Bool {
		
		let validIndex = (sectionIndex > 0) && (sectionIndex < childDelegates.count)
		
		return validIndex && propagationMode == .Section
	}
}

extension PropagatingTableDelegate: CascadingTableDelegate {
	
	func prepare(tableView tableView: UITableView) {
		
		childDelegates.forEach { delegate in
			delegate.prepare(tableView: tableView)
		}
		
	}
}

// MARK: - UITableViewDataSource

extension PropagatingTableDelegate: UITableViewDataSource {
	
	// MARK: - Mandatory methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if propagationMode == .Row {
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
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let validSectionMode = (propagationMode == .Section) && (indexPath.section < childDelegates.count)
		let validRowMode = (propagationMode == .Row) && (indexPath.row < childDelegates.count)
		
		if validSectionMode  {
			
			let indexSection = indexPath.section
			return childDelegates[indexSection].tableView(tableView, cellForRowAtIndexPath: indexPath)
		}
				
		if validRowMode {
			let indexRow = indexPath.row
			return childDelegates[indexRow].tableView(tableView, cellForRowAtIndexPath: indexPath)
		}
		
		return UITableViewCell()
	}
	
	// MARK: - Optional methods
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return propagationMode == .Section ? childDelegates.count : 0
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, titleForHeaderInSection: section)
	}
	
	func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, titleForFooterInSection: section)
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return false
		}
		
		return childDelegates[childIndex].tableView?(tableView, canEditRowAtIndexPath: indexPath) ?? false
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return false
		}
		
		return childDelegates[childIndex].tableView?(tableView, canMoveRowAtIndexPath: indexPath) ?? false
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[childIndex].tableView?(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
	}
	
	// TODO: Revisit on how we should implement sectionIndex-related methods later.
	
}

// MARK: - UITableViewDelegate

extension PropagatingTableDelegate: UITableViewDelegate {
	
	
	// MARK: - Display Customization 
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let childIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[childIndex].tableView?(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, willDisplayHeaderView: view, forSection: section)
	}
	
	func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, willDisplayFooterView: view, forSection: section)
	}
	
	func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[validIndex].tableView?(tableView, didEndDisplayingCell: cell, forRowAtIndexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
	}
	
	func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return
		}
		
		childDelegates[section].tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
	}
	
	// MARK: - Height Support
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
	
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return CGFloat.min
		}
		
		
		return childDelegates[validIndex].tableView?(tableView, heightForRowAtIndexPath: indexPath) ?? CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat.min
		}
		
		return childDelegates[section].tableView?(tableView, heightForHeaderInSection: section) ?? CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat.min
		}
		
		return childDelegates[section].tableView?(tableView, heightForFooterInSection: section) ?? CGFloat.min
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return CGFloat.min
		}
		
		return childDelegates[validIndex].tableView?(tableView, estimatedHeightForRowAtIndexPath: indexPath) ?? CGFloat.min
	}
	
	func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat.min
		}
		
		return childDelegates[section].tableView?(tableView, estimatedHeightForHeaderInSection: section) ?? CGFloat.min
	}
	
	func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return CGFloat.min
		}
		
		return childDelegates[section].tableView?(tableView, estimatedHeightForFooterInSection: section) ?? CGFloat.min
	}
	
	// MARK: - Header and Footer View
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, viewForHeaderInSection: section)
	}
	
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		guard isSectionMethodAllowed(sectionIndex: section) else {
			return nil
		}
		
		return childDelegates[section].tableView?(tableView, viewForFooterInSection: section)
	}
	
	// MARK: - Editing
	
	func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return .None
		}
		
		return childDelegates[validIndex].tableView?(tableView, editingStyleForRowAtIndexPath: indexPath) ?? .None
	}
	
	func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return nil
		}
		
		return childDelegates[validIndex].tableView?(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return nil
		}
		
		return childDelegates[validIndex].tableView?(tableView, editActionsForRowAtIndexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return false
		}
		
		return childDelegates[validIndex].tableView?(tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath) ?? false
	}
	
	func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[validIndex].tableView?(tableView, willBeginEditingRowAtIndexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
			return
		}
		
		childDelegates[validIndex].tableView?(tableView, didEndEditingRowAtIndexPath: indexPath)
	}
    
    // MARK: - Selection
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return false
        }
        
        
        return childDelegates[validIndex].tableView?(tableView, shouldHighlightRowAtIndexPath: indexPath) ?? false
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didHighlightRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didUnhighlightRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return nil
        }
        
        return childDelegates[validIndex].tableView?(tableView, willSelectRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return nil
        }
        
        return childDelegates[validIndex].tableView?(tableView, willDeselectRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, didDeselectRowAtIndexPath: indexPath)        
    }
    
    // MARK: - Copy & Paste
    
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return false
        }
        
        return childDelegates[validIndex].tableView?(tableView, shouldShowMenuForRowAtIndexPath: indexPath) ?? false
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return false
        }
        
        return childDelegates[validIndex].tableView?(tableView, canPerformAction: action, forRowAtIndexPath: indexPath, withSender: sender) ?? false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return
        }
        
        childDelegates[validIndex].tableView?(tableView, performAction: action, forRowAtIndexPath: indexPath, withSender: sender)   
        
    }
    
    // MARK: - Focus
        
    @available(iOS 9.0, *)
    func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        guard let validIndex = getValidChildIndex(indexPath: indexPath) else {
            return false
        }
        
        return childDelegates[validIndex].tableView?(tableView, canFocusRowAtIndexPath: indexPath) ?? false
    }
}
