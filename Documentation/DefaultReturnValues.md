# UITableViewDelegate and UITableViewDataSource Default Return Values

Below are the list of default return values of `UITableViewDelegate` and `UITableViewDataSource` methods that requires one. Defaults values are returned for invalid parameters (e.g. out of bounds indexes) or indexes where the corresponding child doesn't implement the requested methods. These documentation applies for `PropagatingTableDelegate` and its subclasses, including `CascadingRootTableDelegate` and `CascadingSectionTableDelegate`.

`PropagatingTableDelegate` has `propagationMode` property, which could be set to `.Row` or `.Section`. Every result that applies to `.Row` mode will apply to `CascadingSectionTableDelegate`, and `.Section` will apply to `CascadingRootTableDelegate`.

## UITableViewDataSource methods

- `tableView(_:numberOfRowsInSection:)`
	- `.Row`: Number of `childDelegates`.
	- `.Section`: 0.
- `tableView(_:cellForRowAt:)`
	- New `UITableViewCell` instance.
- `numberOfSections(in:)`
	- `.Row`: 0.
	- `.Section`: Number of `childDelegates`.
- `tableView(_:titleForHeaderInSection:)`
	- 	`nil`.
-  `tableView(_:canEditRowAt:)`
	-  `false`.
-  `tableView(_:titleForFooterInSection:)`
	-  `nil`.
-  `tableView(_:canEditRowAt:)`
	-  `false`.
-  `tableView(_:canMoveRowAt:)`
	-  `false`.


## UITableViewDelegate methods

### Height support

- `tableView(_:heightForRowAt:)`
	- `UITableViewAutomaticDimension`.
- `tableView(_:heightForHeaderInSection:)`
	- `CGFloat(0)`.
- `tableView(_:heightForFooterInSection:)`
	- `CGFloat(0)`
- `tableView(_:estimatedHeightForRowAt:)`
	- Corresponding child's `tableView(_:heightForRowAt:)` result if available, and
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

- `tableView(_:editingStyleForRowAt:)`
	- `UITableViewCellEditingStyle.None`.
- `tableView(_:titleForDeleteConfirmationButtonForRowAt:)`
	- `nil`.
- `tableView(_:editActionsForRowAt:)`
	- `nil`.
- `tableView(_:shouldIndentWhileEditingRowAt:)`
	- `false`.

### Selection

- `tableView(_:shouldHighlightRowAt:)`
	- `true`.
- `tableView(_:willSelectRowAt:)`
	- `NSIndexPath` parameter that passed on the method call.
- `tableView(_:willDeselectRowAt:)`
	- `NSIndexPath` parameter that passed on the method call.

### Copy and Paste

- `tableView(_:shouldShowMenuForRowAt:)`
	- 	`false`.
- `tableView(_:canPerformAction:forRowAt:withSender:)`
	- `false`.

### Focus

- `tableView(_:canFocusRowAt:)`
	- `false`.

### Reorder

- `tableView(_:indentationLevelForRowAt:)`
	- 0.

