//
//  DestinationReviewUserCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class DestinationReviewUserCell: UITableViewCell {

	/// Marks and sets whether this instance's bottom border view is hidden or not.
	var hideBottomBorder: Bool {
		get {
			return bottomBorderView?.hidden ?? true
		}
		set {
			bottomBorderView?.hidden = newValue
		}
	}
	
	@IBOutlet private weak var userNameLabel: UILabel!
	@IBOutlet private weak var userReviewLabel: UILabel!
	
	@IBOutlet private weak var bottomBorderView: UIView?
	
	@IBOutlet private var starImageViews: [UIImageView]?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		resetLabels()
		configure(rating: 0)
    }
	
	// MARK: - Public methods
	
	static func preferredHeight(userReview userReview: String) -> CGFloat {
		
		let mainScreen = UIScreen.mainScreen()
		let screenWidth = mainScreen.bounds.width
		
		let horizontalPadding = CGFloat(40)
		let reviewTextWidth = screenWidth - horizontalPadding
		
		let reviewFont = UIFont.systemFontOfSize(14.0)
		let reviewTextHeight = userReview.displayHeight(width: reviewTextWidth, font: reviewFont)
		
		let topHeight = CGFloat(39)
		
		let verticalPadding = CGFloat(20)
		
		return topHeight + reviewTextHeight + verticalPadding
	}
	
	func configure(userName userName: String, userReview: String, rating: Int) {
		userNameLabel.text = userName
		userReviewLabel.text = userReview
		configure(rating: rating)
	}
	
	// MARK: - Private methods
	
	private func resetLabels() {
		userNameLabel.text = nil
		userReviewLabel.text = nil
	}
	
	private func configure(rating rating: Int) {
		
		guard let starImageViews = starImageViews else {
			return
		}
		
		starImageViews.enumerate()
			.forEach { index, imageView in
				
				let insideRating = index < rating
				let starImage = insideRating ? UIImage.yellowStar() : UIImage.greyStar()
				
				imageView.image = starImage
		}
	}
	
    
}
