//
//  DestinationTopPhotoCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DestinationTopPhotoCell: UITableViewCell {

	@IBOutlet private weak var photoImageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.photoImageView.image = nil
	}
	
	/**
	Preferred height to display this class's instance.
	
	- returns: `CGFloat` value.
	*/
	static func preferredHeight() -> CGFloat {
		
		let screenWidth = UIScreen.mainScreen().bounds.width
		let ratio = CGFloat(262.0 / 375.0)
		
		return screenWidth * ratio
	}
	
	/**
	Configures this instance using passed `image`.
	
	- parameter image: `UIImage` optional.
	*/
	func configure(image image: UIImage?) {
		photoImageView.image = image
	}
    
}
