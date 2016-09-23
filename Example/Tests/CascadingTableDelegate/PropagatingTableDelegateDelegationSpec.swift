//
//  PropagatingTableDelegateDelegationSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 9/23/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateDelegationSpec: QuickSpec {
	
	override func spec() {
		
		// Display customization
		
		pending("tableView(_: willDisplayCell: forRowAtIndexPath:)", {})
		
		pending("tableView(_: willDisplayHeaderView: forSection:)", {})
		
		pending("tableView(_: didEndDisplayingCell: forRowAtIndexPath:)", {})
		
		pending("tableView(_: didEndDisplayingFooterView: forSection:)", {})
		
		// Variable height support
		
		pending("tableView(_: heightForRowAtIndexPath:)", {})
		
		pending("tableView(_: heightForHeaderInSection:)", {})
		
		pending("tableView(_: heightForFooterInSection:)", {})
		
		pending("tableView(_: estimatedHeightForRowAtIndexPath:)", {})
		
		pending("tableView(_: estimatedHeightForHeaderInSection:)", {})
		
		pending("tableView(_: estimatedHeightForFooterInSection:)", {})
		
		// Section header and footer information
		
		pending("tableView(_: viewForHeaderInSection:)", {})
		
		pending("tableView(_: viewForFooterInSection:)", {})
		
		pending("tableView(_: accessoryButtonTappdForRowWithIndexPath:)", {})
		
		// Selection
		
		pending("tableView(_: shouldHighlightRowAtIndexPath:)", {})
		
		pending("tableView(_: didHighlightRowAtIndexPath:)", {})
		
		pending("tableView(_: didUnhighlightRowAtIndexPath:)", {})
		
		pending("tableView(_: willSelectRowAtIndexPath:)", {})
		
		pending("tableView(_: willDeselectRowAtIndexPath:)", {})
		
		pending("tableView(_: didSelectRowAtIndexPath:)", {})
		
		pending("tableView(_: didDeselectRowAtIndexPath:)", {})
		
		// Editing
		
		pending("tableView(_: editingStyleForRowAtIndexPath:)", {})
		
		pending("tableView(_: titleForDeleteConfirmationButtonForRowAtIndexPath:)", {})
		
		pending("tableView(_: editActionsForRowAtIndePath:)", {})
		
		pending("tableView(_: shouldIndentWhileEditingRowAtIndexPath:)", {})
		
		pending("tableView(_: willBeginEditingRowAtIndexPath:)", {})
		
		pending("tableView(_: didEndEditingRowAtIndexPath:)", {})
		
		// Moving/reordering
		
		pending("tableView(_: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath:)", {})
		
		// Indentation
		
		pending("tableView(_: indentationLevelForRowAtIndexPath:)", {})
		
		// Copy / Paste
		pending("tableView(_: shouldShowMenuForRowAtIndexPath:)", {})
		pending("tableView(_: canPerformAction: forRowAtIndexPath: withSender:)", {})
		pending("tableView(_: performAction: forRowAtIndexPath: withSender:)", {})
		
		// Focus
		pending("tableView(_: canFocusRowAtIndexPath:)", {})
		pending("tableView(_: shouldUpdateFocusInContext)", {})
		pending("tableView(_: didUpdateFocusInContext: withAnimationCoordinator:)", {})
		pending("indexPathForPreferredFocusedViewInTableView(_:)", {})
	}
}