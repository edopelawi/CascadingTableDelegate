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
			return bottomBorderView?.isHidden ?? true
		}
		set {
			bottomBorderView?.isHidden = newValue
		}
	}
	
	@IBOutlet fileprivate weak var userNameLabel: UILabel!
	@IBOutlet fileprivate weak var userReviewLabel: UILabel!
	
	@IBOutlet fileprivate weak var bottomBorderView: UIView?
	
	@IBOutlet fileprivate var starImageViews: [UIImageView]?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		resetLabels()
		configure(rating: 0)
    }
	
	// MARK: - Public methods
	
	static func preferredHeight(userReview: String) -> CGFloat {
		
		let mainScreen = UIScreen.main
		let screenWidth = mainScreen.bounds.width
		
		let horizontalPadding = CGFloat(40)
		let reviewTextWidth = screenWidth - horizontalPadding
		
		let reviewFont = UIFont.systemFont(ofSize: 14.0)
		let reviewTextHeight = userReview.displayHeight(width: reviewTextWidth, font: reviewFont)
		
		let topHeight = CGFloat(39)
		
		let verticalPadding = CGFloat(20)
		
		return topHeight + reviewTextHeight + verticalPadding
	}
	
	func configure(userName: String, userReview: String, rating: Int) {
		userNameLabel.text = userName
		userReviewLabel.text = userReview
		configure(rating: rating)
	}
	
	// MARK: - Private methods
	
	fileprivate func resetLabels() {
		userNameLabel.text = nil
		userReviewLabel.text = nil
	}
	
	fileprivate func configure(rating: Int) {
		
		guard let starImageViews = starImageViews else {
			return
		}
		
		starImageViews.enumerated()
			.forEach { index, imageView in
				
				let insideRating = index < rating
				let starImage = insideRating ? UIImage.yellowStar() : UIImage.greyStar()
				
				imageView.image = starImage
		}
	}
	
    
}
