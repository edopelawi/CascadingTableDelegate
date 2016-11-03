//
//  DestinationInfoListRowDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationInfoListRowDelegate: CascadingBareTableDelegate {
	
	/// Cell identifier that will be used by this class. Kindly register this to the section delegate.
	static let cellIdentifier = DestinationInfoCell.nibIdentifier()

	fileprivate var info: DestinationInfo?
	
	convenience init(info: DestinationInfo) {
		self.init(index: 0, childDelegates: [])
		self.info = info
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let identifier = DestinationInfoListRowDelegate.cellIdentifier
		return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
		return DestinationInfoCell.preferredHeight(infoType: info?.type, infoText: info?.text)
	}		
	
	func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
		
		guard let cell = cell as? DestinationInfoCell else {
			return
		}
		
		cell.configure(infoType: info?.type, infoText: info?.text)
	}
}
