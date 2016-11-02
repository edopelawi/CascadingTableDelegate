//
//  DestinationInfoCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DestinationInfoCell: UITableViewCell {

	@IBOutlet private weak var infoTypeLabel: UILabel!
	@IBOutlet private weak var infoTextLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        resetLabels()
    }
	
	override func prepareForReuse() {
		super.awakeFromNib()
		resetLabels()
	}
	
	// MARK: - Public methods
	
	static func preferredHeight(infoType infoType: String?, infoText: String?) -> CGFloat {
		
		let mainScreen = UIScreen.mainScreen()
		let screenWidth = mainScreen.bounds.width
		
		let horizontalPadding = CGFloat(20)
		let expectedWidth = screenWidth - (horizontalPadding * 2.0)
		
		let infoTypeFont = UIFont.boldSystemFontOfSize(14.0)
		let infoTypeHeight = infoType?.displayHeight(width: expectedWidth, font: infoTypeFont) ?? CGFloat(0)
		
		let infoTextFont = UIFont.systemFontOfSize(14.0)
		let infoTextHeight = infoText?.displayHeight(width: expectedWidth, font: infoTextFont) ?? CGFloat(0)
		
		let verticalPadding = CGFloat(10)
		
		return infoTypeHeight + infoTextHeight + (verticalPadding * 2.0)
	}
	
	func configure(infoType infoType: String?, infoText: String?) {
		infoTypeLabel.text = infoType
		infoTextLabel.text = infoText
	}
	
	// MARK: - Private methods
	
	private func resetLabels() {
		infoTypeLabel.text = nil
		infoTextLabel.text = nil
	}
    
}
