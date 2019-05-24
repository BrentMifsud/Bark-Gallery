//
//  ViewController.swift
//  Bark Gallery
//
//  Created by Brent Mifsud on 2019-05-12.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit

class RandomDogViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var fetchButton: UIButton!
	@IBOutlet weak var errorLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		errorLabel.isHidden = true
		fetchButton.setTitle("Fetch!", for: .normal)
		imageView.isHidden = false

		DogApi.requestRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
	}

	func handleRandomImageResponse(imageData: DogApiResponse?, error: Error?) {

		guard let imageUrl = URL(string: imageData?.message ?? "") else {
			handleFailedResponse()
			return
		}

		DogApi.requestDogImage(url: imageUrl, completionHandler: handleImageFileResponse(image:error:))
	}

	func handleImageFileResponse(image: UIImage?, error: Error?) {
		DispatchQueue.main.async {
			self.imageView.image = image
		}
	}

	func handleFailedResponse(){
		DispatchQueue.main.async {
			self.errorLabel.isHidden = false
			self.imageView.isHidden = true
			self.fetchButton.setTitle("Try Again", for: .normal)
		}
	}

	@IBAction func nextDogButtonPressed(_ sender: Any) {
		imageView.isHidden = false

		DogApi.requestRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
	}

}

