//
//  WelcomeViewController.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/28/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

	convenience init() {
		self.init(nibName: "WelcomeViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = ""
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.isNavigationBarHidden = true
	}
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - Private methods
	
	@IBAction fileprivate func nextButtonTapped(_ sender: AnyObject) {
		
		let destinationViewController = DestinationViewController()
		navigationController?.pushViewController(destinationViewController, animated: true)
		
	}

}
