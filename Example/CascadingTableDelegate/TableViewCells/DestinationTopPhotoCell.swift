//
//  DestinationTopPhotoCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class DestinationTopPhotoCell: UITableViewCell {

	@IBOutlet fileprivate weak var photoImageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.photoImageView.image = nil
	}
	
	/**
	Preferred height to display this class's instance.
	
	- returns: `CGFloat` value.
	*/
	static func preferredHeight() -> CGFloat {
		
		let screenWidth = UIScreen.main.bounds.width
		let ratio = CGFloat(262.0 / 375.0)
		
		return screenWidth * ratio
	}
	
	/**
	Configures this instance using passed `image`.
	
	- parameter image: `UIImage` optional.
	*/
	func configure(image: UIImage?) {
		photoImageView.image = image
	}
    
}
