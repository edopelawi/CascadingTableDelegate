//
//  WelcomeViewController.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBarHidden = true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Private methods
	
	@IBAction private func nextButtonTapped(sender: AnyObject) {
		
		let destinationViewController = DestinationViewController()
		navigationController?.pushViewController(destinationViewController, animated: true)
		
	}

}
