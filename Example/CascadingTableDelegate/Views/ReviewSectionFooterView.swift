//
//  ReviewSectionFooterView.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class ReviewSectionFooterView: UIView {

	@IBOutlet private weak var showMoreButton: UIButton?
	
	/// This instance's button text.
	var buttonText: String? {
		get {
			return showMoreButton?.titleLabel?.text
		}
		set {
			showMoreButton?.titleLabel?.text = buttonText
		}
	}
	
	/// Executed when this instance's button tapped.
	var onButtonTapped: (Void -> Void)?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		showMoreButton?.setRoundedCorner()
	}
	
	/// Factory method of this class.
	static func view() -> ReviewSectionFooterView {
		
		let mainBundle = NSBundle.mainBundle()
		let nibs = mainBundle.loadNibNamed("ReviewSectionFooterView", owner: nil, options: nil)
		
		return nibs.first as? ReviewSectionFooterView ?? ReviewSectionFooterView()
	}
	
	/// Prefered height to display this instance.
	static func preferredHeight() -> CGFloat {
		return CGFloat(46)
	}
		
	@IBAction private func showMoreButtonTapped(sender: AnyObject) {
		onButtonTapped?()
	}
}
