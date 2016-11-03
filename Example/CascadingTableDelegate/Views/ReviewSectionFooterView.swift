//
//  ReviewSectionFooterView.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class ReviewSectionFooterView: UIView {

	@IBOutlet fileprivate weak var showMoreButton: UIButton?
	@IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView?
	
	/// This instance's button text.
	var buttonText: String? {
		get {
			return showMoreButton?.titleLabel?.text
		}
		set {
			showMoreButton?.setTitle(newValue, for: UIControlState())
		}
	}
	
	/// Executed when this instance's button tapped.
	var onButtonTapped: ((Void) -> Void)?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		activityIndicator?.isHidden = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		showMoreButton?.setRoundedCorner()
	}
	
	
	/// Factory method of this class.
	static func view() -> ReviewSectionFooterView {
		
		let mainBundle = Bundle.main
		let nibs = mainBundle.loadNibNamed("ReviewSectionFooterView", owner: nil, options: nil)
		
		return nibs!.first as? ReviewSectionFooterView ?? ReviewSectionFooterView()
	}
	
	/// Prefered height to display this instance.
	static func preferredHeight() -> CGFloat {
		return CGFloat(46)
	}
	
	/// Shows this instance's activity indicator and hides its button text.
	func startActivityIndicator() {

		if let indicator = activityIndicator , !indicator.isHidden {
			return
		}
		
		activityIndicator?.isHidden = false
		activityIndicator?.startAnimating()
		
		showMoreButton?.titleLabel?.alpha = 0.0
	}
	
	/// Hides this instance's activity indicator and returns its button text.
	func stopActivityIndicator() {
		
		if let indicator = activityIndicator , indicator.isHidden {
			return
		}
		
		activityIndicator?.isHidden = true
		activityIndicator?.stopAnimating()
		
		showMoreButton?.titleLabel?.alpha = 1.0
	}
		
	@IBAction fileprivate func showMoreButtonTapped(_ sender: AnyObject) {
		onButtonTapped?()
	}
}
