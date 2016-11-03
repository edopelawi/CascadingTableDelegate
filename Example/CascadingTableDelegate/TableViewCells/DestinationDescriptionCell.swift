//
//  DestinationDescriptionCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class DestinationDescriptionCell: UITableViewCell {

	@IBOutlet fileprivate weak var descriptionLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.text = nil
    }
	
	override func prepareForReuse() {
		super.awakeFromNib()
		descriptionLabel.text = nil
	}
	
	/**
	Returns preferred height for displaying this class' instance for passed `displayText`.
	
	- parameter displayText: `String` optional that will be displayed.
	
	- returns: `CGFloat` value.
	*/
	static func preferredHeight(displayText: String?) -> CGFloat {
		
		let verticalPadding = CGFloat(22)
		
		guard let validText = displayText else {
			return verticalPadding
		}
		
		let horizontalPadding = CGFloat(30)
		let screenWidth = UIScreen.main.bounds.width
		
		let textWidth = screenWidth - horizontalPadding
		let textFont = UIFont.systemFont(ofSize: 14)
		
		let textHeight = validText.displayHeight(width: textWidth, font: textFont)
		
		return textHeight + verticalPadding
	}
 
	
	/**
	Configures this instance using passed `description`.
	
	- parameter description:	`String` optional.
	*/
	func configure(description: String?) {
		descriptionLabel.text = description
	}
}
