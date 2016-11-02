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
	@IBOutlet private weak var activityIndicator: UIActivityIndicatorView?
	
	/// This instance's button text.
	var buttonText: String? {
		get {
			return showMoreButton?.titleLabel?.text
		}
		set {
			showMoreButton?.setTitle(newValue, forState: .Normal)
		}
	}
	
	/// Executed when this instance's button tapped.
	var onButtonTapped: (Void -> Void)?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		showMoreButton?.setRoundedCorner()
		activityIndicator?.hidden = true
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
	
	/// Shows this instance's activity indicator and hides its button text.
	func startActivityIndicator() {

		if let indicator = activityIndicator where !indicator.hidden {
			return
		}
		
		activityIndicator?.hidden = false
		activityIndicator?.startAnimating()
		
		showMoreButton?.titleLabel?.alpha = 0.0
	}
	
	/// Hides this instance's activity indicator and returns its button text.
	func stopActivityIndicator() {
		
		if let indicator = activityIndicator where indicator.hidden {
			return
		}
		
		activityIndicator?.hidden = true
		activityIndicator?.stopAnimating()
		
		showMoreButton?.titleLabel?.alpha = 1.0
	}
		
	@IBAction private func showMoreButtonTapped(sender: AnyObject) {
		onButtonTapped?()
	}
}
