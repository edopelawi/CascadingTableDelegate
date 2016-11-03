//
//  DestinationReviewRatingCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class DestinationReviewRatingCell: UITableViewCell {

	@IBOutlet fileprivate var starImageViews: [UIImageView]?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		configure(rating: 0)
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		configure(rating: 0)
	}
		
	static func preferredHeight() -> CGFloat {
		return CGFloat(39)
	}
	
	/// Configures this instance with passed `rating`. Valid values are between 0 - 5. Behaviour for invalid values is undefined.
	func configure(rating: Int) {
		
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

extension UIImage {
	
	static func greyStar() -> UIImage? {
		return UIImage(named: "icoStarGrey")
	}
	
	static func yellowStar() -> UIImage? {
		return UIImage(named: "icoStarYellow")
	}
}
