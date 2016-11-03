//
//  DestinationReviewUserRowDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CascadingTableDelegate

struct DestinationReviewUserRowViewModel {
	let userName: String
	let userReview: String
	let rating: Int
}

class DestinationReviewUserRowDelegate: CascadingBareTableDelegate {
	
	/// Cell identifier that will be used by this instance. Kindly register this on section-level delegate that will use this class' instance.
	static let cellIdentifier = DestinationReviewUserCell.nibIdentifier()
	
	fileprivate var viewModel: DestinationReviewUserRowViewModel?
	
	convenience init(viewModel: DestinationReviewUserRowViewModel) {
		self.init(index: 0, childDelegates: [])
		self.viewModel = viewModel
	}
	
}

extension DestinationReviewUserRowDelegate {		
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let identifier = DestinationReviewUserRowDelegate.cellIdentifier
		return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
		
		let userReview = viewModel?.userReview ?? ""
		return DestinationReviewUserCell.preferredHeight(userReview: userReview)
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
		
		return DestinationReviewUserCell.preferredHeight(userReview: "")
	}
	
	func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
		
		guard let cell = cell as? DestinationReviewUserCell,
			let viewModel = viewModel else {
			return
		}
		
		cell.configure(
			userName: viewModel.userName,
			userReview: viewModel.userReview,
			rating: viewModel.rating
		)
		
		let lastRow = (index + 1) == parentDelegate?.childDelegates.count
		
		cell.hideBottomBorder = lastRow
	}
}
