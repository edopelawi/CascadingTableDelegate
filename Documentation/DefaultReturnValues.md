# UITableViewDelegate and UITableViewDataSource Default Return Values

Below are the list of default return values of `UITableViewDelegate` and `UITableViewDataSource` methods that requires one. Defaults values are returned for invalid parameters (e.g. out of bounds indexes) or indexes where the corresponding child doesn't implement the requested methods. These documentation applies for `PropagatingTableDelegate` and its subclasses, including `CascadingRootTableDelegate` and `CascadingSectionTableDelegate`.

`PropagatingTableDelegate` has `propagationMode` property, which could be set to `.Row` or `.Section`. Every result that applies to `.Row` mode will apply to `CascadingSectionTableDelegate`, and `.Section` will apply to `CascadingRootTableDelegate`.

## UITableViewDataSource methods

- `tableView(_:numberOfRowsInSection:)`
	- `.Row`: Number of `childDelegates`.
	- `.Section`: 0.
- `tableView(_:cellForRowAtIndexPath)`
	- New `UITableViewCell` instance.
- `numberOfSectionsInTableView(_:)`
	- `.Row`: 0.
	- `.Section`: Number of `childDelegates`.
- `tableView(_:titleForHeaderInSection:)`
	- 	`nil`.
-  `tableView(_:canEditRowAtIndexPath)`
	-  `false`.
-  `tableView(_:titleForFooterInSection:)`
	-  `nil`.
-  `tableView(_:canEditRowAtIndexPath:)`
	-  `false`.
-  `tableView(_:canMoveRowAtIndexPath:)`
	-  `false`.


## UITableViewDelegate methods

### Height support

- `tableView(_:heightForRowAtIndexPath:)`
	- `UITableViewAutomaticDimension`.
- `tableView(_:heightForHeaderInSection:)`
	- `CGFloat(0)`.
- `tableView(_:heightForFooterInSection:)`
	- `CGFloat(0)`
- `tableView(_:estimatedHeightForRowAtIndexPath)`
	- Corresponding child's `tableView(_:heightForRowAtIndexPath:)` result if available, and
	- `UITableViewAutomaticDimension` if not.
- `tableView(_:estimatedHeightForHeaderInSection:)`
	- Corresponding child's `tableView(_:heightForHeaderInSection:)` result if available, and
	- `CGFloat(0)` if not.
- `tableView(_:estimatedHeightForFooterInSection:)`
	- Corresponding child's `tableView(_:heightForFooterInSection:)` result if available, and
	- `CGFloat(0)` if not.

### Header and Footer View

- `tableView(_:viewForHeaderInSection:)`
	- `nil`.
- `tableView(_:viewForFooterInSection:)`
	- `nil`.

### Editing

- `tableView(_:editingStyleForRowAtIndexPath:)`
	- `UITableViewCellEditingStyle.None`.
- `tableView(_:titleForDeleteConfirmationButtonForRowAtIndexPath:)`
	- `nil`.
- `tableView(_:editActionsForRowAtIndexPath:)`
	- `nil`.
- `tableView(_:shouldIndentWhileEditingRowAtIndexPath:)`
	- `false`.

### Selection

- `tableView(_:shouldHighlightRowAtIndexPath:)`
	- `true`.
- `tableView(_:willSelectRowAtIndexPath:)`
	- `NSIndexPath` parameter that passed on the method call.
- `tableView(_:willDeselectRowAtIndexPath:)`
	- `NSIndexPath` parameter that passed on the method call.

### Copy and Paste

- `tableView(_:shouldShowMenuForRowAtIndexPath)`
	- 	`false`.
- `tableView(_:canPerformAction:forRowAtIndexPath:withSender:)`
	- `false`.

### Focus

- `tableView(_:canFocusRowAtIndexPath:)`
	- `false`.

### Reorder

- `tableView(_:indentationLevelForRowAtIndexPath:)`
	- 0.	

