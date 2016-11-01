//
//  DestinationReviewRatingCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DestinationReviewRatingCell: UITableViewCell {

	@IBOutlet private var starImageViews: [UIImageView]?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		configure(rating: 0)
    }
	
	override func prepareForReuse() {
		self.prepareForReuse()
		configure(rating: 0)
	}
		
	static func preferredHeight() -> CGFloat {
		return CGFloat(39)
	}
	
	/// Configures this instance with passed `rating`. Valid values are between 0 - 5. Behaviour for invalid values is undefined.
	func configure(rating rating: Int) {
		
		guard let starImageViews = starImageViews else {
			return
		}
		
		starImageViews.enumerate()
		.forEach { index, imageView in
			
			let insideRating = index < (rating - 1)
			let starImage = insideRating ? UIImage.greyStar() : UIImage.yellowStar()
			
			imageView.image = starImage
		}
	}
	
}

extension UIImage {
	
	static func greyStar() -> UIImage? {
		return UIImage(named: "icoStarGrey")
	}
	
	static func yellowStar() -> UIImage? {
		return UIImage(named: "icoStarYellow")
	}
}
