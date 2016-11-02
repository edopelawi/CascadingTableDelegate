//
//  DestinationInfoListRowDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationInfoListRowDelegate: CascadingBareTableDelegate {
	
	/// Cell identifier that will be used by this class. Kindly register this to the section delegate.
	static let cellIdentifier = DestinationInfoCell.nibIdentifier()

	private var info: DestinationInfo?
	
	convenience init(info: DestinationInfo) {
		self.init(index: 0, childDelegates: [])
		self.info = info
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let identifier = DestinationInfoListRowDelegate.cellIdentifier
		return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return DestinationInfoCell.preferredHeight(infoType: info?.type, infoText: info?.text)
	}		
	
}