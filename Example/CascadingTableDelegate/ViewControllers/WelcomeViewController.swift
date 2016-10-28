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
		
		self.navigationController?.navigationBarHidden = true
	}
	
	@IBAction func nextButtonTapped(sender: AnyObject) {
		
		// TODO: Add navigation code here.
		print("Next Button tapped!")
	}

}
