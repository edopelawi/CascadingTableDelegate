# CascadingTableDelegate

[![CI Status](http://img.shields.io/travis/Ricardo Pramana Suranta/CascadingTableDelegate.svg?style=flat)](https://travis-ci.org/Ricardo Pramana Suranta/CascadingTableDelegate)
[![Version](https://img.shields.io/cocoapods/v/CascadingTableDelegate.svg?style=flat)](http://cocoapods.org/pods/CascadingTableDelegate)
[![License](https://img.shields.io/cocoapods/l/CascadingTableDelegate.svg?style=flat)](http://cocoapods.org/pods/CascadingTableDelegate)
[![Platform](https://img.shields.io/cocoapods/p/CascadingTableDelegate.svg?style=flat)](http://cocoapods.org/pods/CascadingTableDelegate)

## Why is this library made?
In common iOS development, `UITableView` have became the bread and butter for building a rich, large pages. To display the contents, `UITableView` uses `UITableViewDelegate` and `UITableViewDataSource`- compliant objects. 

`UITableView` only allows an object to become the `delegate` and `dataSource` - which might led to a unnecessarily huge source code file - a know-it-all [Megamoth method](https://blog.codinghorror.com/new-programming-jargon/). This usually happen on the most used method, such as `tableView(_: cellForRowAtIndexPath:)` and `tableView(_: heightForRowAtIndexPath)`.

# How is this library fixes that?

This library is loosely inspired by [MVVM architecture](https://en.wikipedia.org/wiki/Model–view–viewmodel), a pattern that increasingly become common in iOS development. In MVVM, a `View` may have child `Views`, and the corresponding `ViewModel` may have child `ViewModels`. This allows us to create cleaner code, where each specific `ViewModel` and `View` only knows about themselves. 

MVVM's approach is a stark contrast against the `UITableViewDataSource` and `UITableViewDelegate`. The default approach forces the object / class to know **everything** about the `UITableView` needs, e.g. what `UITableViewCell` object that should be used, its content, its height, the headers and footers, and what happened when user interacts with them.

This library tries to break down the `UITableViewDelegate` and `UITableViewDataSource` into nested, reusable childs by implementing the [Composite pattern](https://en.wikipedia.org/wiki/Composite_pattern), via the `CascadingTableDelegate` protocol:

```

protocol CascadingTableDelegate: UITableViewDataSource, UITableViewDelegate {
	
	/**
	Index of this instance in its parent.
	
	- warning: On implementation, this value should be corresponding to its `index` number in its parent's `childDelegates`.
	
	- note: The passed `NSIndexPath` to this instance's `UITableViewDataSource` and `UITableViewDelegate` method will be affected by this value, e.g. `index` value as `section`, or index as `row`.
	*/
	var index: Int { get set }
	
	/// Array of child `CascadingTableDelegate` instances.
	var childDelegates: [CascadingTableDelegate] { get set }
	
	/**
	Base initializer for this instance.
	
	- parameter index:          `index` value for this instance. May be changed later.
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
In a sense, `CascadingTableDelegate` allows its implementer to have `childDelegates`, where they could propagate the called delegate or data source methods to the corresponding `childDelegate`, based on the passed `NSIndexPath` or section index. If needed, they could handle the method call itself instead of propagating it (e.g. leaf objects).

Knowing that `UITableViewDataSource` and `UITableViewDelegate` has a lot methods to be propagated, we did the heavy lifting by implementing `PropagatingTableDelegate`:


```
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
}

```
This class implements all the major delegate and data source methods and has `propagationMode` that will propagates the call to its child, except section-specific and data-moving methods (e.g. `tableView(_: moveRowAtIndexPath: toIndexPath:)`), since it's unclear how to propagate them. In the future, the propagating-heavy classes should subclass from this class, and call its method in [Chain-of-responsibility](https://en.wikipedia.org/wiki/Chain-of-responsibility_pattern) style.

This library is still in progress, and I'd love to have other contributors! Just ask me if you want to contribute :)

## TODOs

- Finish `PropagatingTableDelegate`
- Create root level, ready-to-use `CascadingTableDelegate`-compliant class
- Update to Swift 3.
- Create sample for a page with rich and long content.
- Publish to GitHub.
- (Later) Create section and row level `CascadingTableDelegate`-compliant class that enables this library to be used easily.

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

Ricardo Pramana Suranta, ricardo@icehousecorp.com

## License

CascadingTableDelegate is available under the MIT license. See the LICENSE file for more info.
