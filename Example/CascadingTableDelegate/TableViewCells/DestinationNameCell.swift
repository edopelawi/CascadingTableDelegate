//
//  DestinationNameCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class DestinationNameCell: UITableViewCell {

	@IBOutlet fileprivate weak var nameLabel: UILabel!
	@IBOutlet fileprivate weak var locationLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        resetLabels()
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		resetLabels()
	}
	
	// MARK: - Public methods
	
	/**
	Preferred hegiht to display this class' instance.
	
	- returns: `CGFloat` value.
	*/
	static func preferredHeight() -> CGFloat {
		return CGFloat(52)
	}
	
	
	/**
	Configures this instance with passed `destinationName` and `locationText`.
	
	- parameter destinationName:	`String` optional.
	- parameter locationText:	`String` optional.
	*/
	func configure(destinationName: String?, locationText: String?) {
		nameLabel.text = destinationName
		locationLabel.text = locationText
	}
	
	// MARK: - Private methods
	
	fileprivate func resetLabels() {
		nameLabel.text = nil
		locationLabel.text = nil
	}
	
}
