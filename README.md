# CascadingTableDelegate

[![CI Status](http://img.shields.io/travis/Ricardo Pramana Suranta/CascadingTableDelegate.svg?style=flat)](https://travis-ci.org/Ricardo Pramana Suranta/CascadingTableDelegate)
[![Version](https://img.shields.io/cocoapods/v/CascadingTableDelegate.svg?style=flat)](http://cocoapods.org/pods/CascadingTableDelegate)
[![License](https://img.shields.io/cocoapods/l/CascadingTableDelegate.svg?style=flat)](http://cocoapods.org/pods/CascadingTableDelegate)
[![Platform](https://img.shields.io/cocoapods/p/CascadingTableDelegate.svg?style=flat)](http://cocoapods.org/pods/CascadingTableDelegate)

## Why is this library made?

In common iOS development, `UITableView` have became the bread and butter for building a rich, large pages. To display the contents, `UITableView` uses `UITableViewDelegate` and `UITableViewDataSource`- compliant objects. Still, using `UITableView` has its own problems.

`UITableView` only allows one object to become the `delegate` and `dataSource` - which might led to a unnecessarily huge source code file - a know-it-all [Megamoth method](https://blog.codinghorror.com/new-programming-jargon/). This usually happen on the most used method, such as `tableView(_: cellForRowAtIndexPath:)` and `tableView(_: heightForRowAtIndexPath)`. There are times when I thought "hey, it might be nice if we could split the delegate and data source into each section or row."

# Meet CascadingTableDelegate.

`CascadingTableDelegate` is an approach to break down `UITableViewDelegate` and `UITableViewDataSource` into tree structure, inspired by the [Composite pattern](https://en.wikipedia.org/wiki/Composite_pattern). Here's the simplified structure of the protocol (with less documentation):

```
public protocol CascadingTableDelegate: UITableViewDataSource, UITableViewDelegate {

	/// Index of this instance in its parent's `childDelegates`. Will be set by the parent.
	var index: Int { get set }

	/// Array of child `CascadingTableDelegate` instances.
	var childDelegates: [CascadingTableDelegate] { get set }

	/// Weak reference to this instance's parent `CascadingTableDelegate`.
	weak var parentDelegate: CascadingTableDelegate? { get set }

	/**
	Base initializer for this instance.

	- parameter index:          `index` value for this instance. May be changed later, including this instance's `parentDelegate`.
	- parameter childDelegates: Array of child `CascadingTableDelegate`s.

	- returns: This class' instance.
	*/
	init(index: Int, childDelegates: [CascadingTableDelegate])

	/**
	Preparation method that will be called by this instance's parent, normally in the first time.

	- note: This method could be used for a wide range of purposes, e.g. registering table view cells.
	- note: If this called manually, it should call this instance child's `prepare(tableView:)` method.

	- parameter tableView: `UITableView` instance.
	*/
	func prepare(tableView tableView: UITableView)
}

```

Long story short, this protocol allows us to propagate any `UITableViewDelegate` or `UITableViewDataSource` method call it receives to its child, based on the `section` or `row` value of the passed `NSIndexPath`.

**But UITableViewDelegate and UITableViewDataSource has tons of methods! Who will propagate all those calls?**

Worry not, we already done the heavy lifting by creating **two ready-to-use classes**, `CascadingRootTableDelegate` and `CascadingSectionTableDelegate`. Both implements `CascasdingTableDelegate` protocol and the propagating logic, but with different use case:

- `CascadingRootTableDelegate`:
	- 	Acts as main `UITableViewDelegate` and `UITableViewDataSource` for the `UITableView`.
	-  Propagates **almost** all of delegate and dataSource calls to its `childDelegates`, based on `section` value of the passed `NSIndexPath` and the child's `index`.
	-  Returns number of its `childDelegates` for `numberOfSectionsInTableView(_:)` call.


-  `CascadingSectionTableDelegate`:
	-  	Does not sets itself as `UITableViewDelegate` and `UITableViewDataSource` of the passed `UITableView`, but waits for its `parendDelegate` calls.
	-  Just like `CascadingRootTableDelegate`, it also propagates **almost** all of delegate and dataSource calls to its `childDelegates`, but based by the `row` of passed `NSIndexPath`.
	-  Returns number of its `childDelegates` for `tableView(_:numberOfRowsInSection:)` call.

Both classes also accepts your custom implementations of `CascadingTableDelegate` (which is only `UITableViewDataSource` and `UITableViewDelegate` with few new properties and methods, really) as their `childDelegates`. Plus, you could subclass any of them and call `super` on the overriden methods to let them do the propagation - [Chain-of-responsibility](https://en.wikipedia.org/wiki/Chain-of-responsibility_pattern)-esque style. Check out the sample project to see both of them in action! 😉

## Limitations

### Unpropagated methods

As you know, not all `UITableViewDelegate` methods uses single `NSIndexPath` as their parameter, which makes propagating their calls less intuitive. Based on this reasoning, `CascadingRootTableDelegate` and `CascadingSectionTableDelegate` doesn't implement these `UITableViewDelegate` methods:

 - `sectionIndexTitlesForTableView(_:)`
 - `tableView(_: sectionForSectionIndexTitle: atIndex:)`
 - `tableView(_: moveRowAtIndexPath: toIndexPath:)`
 - `tableView(_: shouldUpdateFocusInContext)`
 - `tableView(_: didUpdateFocusInContext: withAnimationCoordinator:)`
 - `indexPathForPreferredFocusedViewInTableView(_:)`
 - `tableView(_: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath:)`

 Should you need to implement any of those, feel free to subclass both of them and add your own implementations! 😁

### `tableView(_: estimatedHeightFor...:)` method handlings

There are three optional `UITableViewDelegate` methods that used to estimate heights:

- `tableView(_: estimatedHeightForRowAtIndexPath:)`,
- `tableView(_: estimatedHeightForHeaderInSection:)`, and
- `tableView(_: estimatedHeightForFooterInSection:)`.

`CascadingRootTableDelegate` and `CascadingSectionTableDelegate` implements those calls for propagating it to the `childDelegates`. And since both of them implements those, the `UITableView` will **always** call those methods when rendering its rows, headers, and footers.

To prevent layout breaks, `CascadingRootTableDelegate` and `CascadingSectionTableDelegate` will call its childDelegate's `tableView(_: heightFor...:)` counterpart, so the `UITableView` will render it correctly. If your `tableView(_: heightFor...:)` methods use heavy calculations, it is advised to implement the `tableView(_: estimatedHeightFor...:)` counterpart of them.

Should both method not implemented by the `childDelegate`, `CascadingRootTableDelegate` and `CascadingSectionTableDelegate` will return `UITableViewAutomaticDimension` for `tableView(_: estimatedHeightForRowAtIndexPath:)`, and `0` for `tableView(_: estimatedHeightForHeaderInSection:)`, and `tableView(_: estimatedHeightForFooterInSection:)`.

### `weak` declaration for `parentDelegate`

Somehow, Xcode won't add `weak` modifier when you're implementing your own `CascadingTableDelegate` and autocompleting the `parentDelegate` property. Kindly add the `weak` modifier manually to prevent retain cycles. 😁

## TODOs

- Add the sample page with rich and long content.
- Use the sample page in README.md.
- Add `CONTRIBUTING.md`.
- Add `DefaultReturnValues.md`.
- Publish to GitHub.
- Publish to Cocoapods.
- Add Carthage support.
- Update to Swift 3 and check for new delegate / datasource methods in iOS 10.
- (Later) Create easier abstraction that allows easier and clearer use for this lib. Something like [Shoyu-esque](https://github.com/yukiasai/Shoyu).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CascadingTableDelegate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CascadingTableDelegate"
```

## Author

Ricardo Pramana Suranta, ricardo.pramana@gmail.com

## License

CascadingTableDelegate is available under the MIT license. See the LICENSE file for more info.
