//
//  ViewController.swift
//  ClickableImage
//
//  Created by fishcharlie on 08/21/2018.
//  Copyright (c) 2018 fishcharlie. All rights reserved.
//

import ClickableImage
import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var statusLabel: UILabel!
	
	@IBAction func toggle(_ sender: Any) {
		imageView.toggleClickableExpand()
		updateStatusLabel()
	}
	@IBAction func on(_ sender: Any) {
		imageView.enableClickableExpand()
		updateStatusLabel()
	}
	@IBAction func off(_ sender: Any) {
		imageView.disableClickableExpand()
		updateStatusLabel()
	}
	
	func updateStatusLabel() {
		statusLabel.text = "Image is\(imageView.isClickableExpandEnabled ? "" : " not") clickable"
	}
}

