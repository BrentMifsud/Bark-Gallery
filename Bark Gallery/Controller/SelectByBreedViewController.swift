//
//  SelectByBreedViewController.swift
//  Bark Gallery
//
//  Created by Brent Mifsud on 2019-05-22.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit

fileprivate let emptyBreed = "Select a Breed"
fileprivate let emptySubBreed = "Select a Sub-Breed"

class SelectByBreedViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var fetchButton: UIButton!
	@IBOutlet weak var breedPicker: UIPickerView!
	@IBOutlet weak var errorLabel: UILabel!

	var breeds = [emptyBreed]
	var subBreeds = [emptySubBreed]
	var selectedBreed = emptyBreed
	var selectedSubBreed = emptySubBreed
	var breedDict = [String : [String]]()

	override func viewDidLoad() {
        super.viewDidLoad()
		breedPicker.delegate = self

		errorLabel.isHidden = true
		fetchButton.setTitle("Fetch!", for: .normal)
		imageView.isHidden = false
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		DogApi.requestAllBreeds(completionHandler: populateBreedsList(breedData:error:))

	}

	func requestDogImage() {
		guard selectedBreed != emptyBreed else {
			return
		}

		let selectByBreed =	selectedBreed != emptyBreed	&& selectedSubBreed == emptySubBreed

		let selectBySubBreed = selectedBreed != emptyBreed && selectedSubBreed != emptySubBreed

		if selectByBreed {
			DogApi.requestRandomImage(breed: selectedBreed, subBreed: nil, completionHandler: handleRandomImageResponse(imageData:error:))
		} else if selectBySubBreed {
			DogApi.requestRandomImage(breed: selectedBreed, subBreed: selectedSubBreed, completionHandler: handleRandomImageResponse(imageData:error:))
		}
	}

	func populateBreedsList(breedData: DogApiBreedsResponse?, error: Error?){
		guard let breedData = breedData else { return }

		breedDict = breedData.message

		for breed in Array(breedDict.keys).sorted() {
			breeds.append(breed)
		}

		DispatchQueue.main.async {
			self.breedPicker.reloadAllComponents()
		}
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

}

extension SelectByBreedViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 0 {
			return breeds.count
		} else {
			return subBreeds.count
		}
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if component == 0 {
			return "\(breeds[row])"
		} else {
			return "\(subBreeds[row])"
		}
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// if the placeholder row in the breed list is selected, do nothing
		guard pickerView.selectedRow(inComponent: 0) != 0 else { return }

		if component == 0{
			pickerView.selectRow(0, inComponent: 1, animated: false)
			selectedSubBreed = subBreeds[pickerView.selectedRow(inComponent: 1)]
			selectedBreed = breeds[row]

			// clear all but the placeholder value in the subbreeds array
			subBreeds.removeLast(subBreeds.count-1)

			// populate subbreeds for the newly selected breed
			if let subBreeds = breedDict[selectedBreed] {
				self.subBreeds.append(contentsOf: subBreeds.sorted())
				breedPicker.reloadComponent(1)
			}
		} else {
			selectedSubBreed = subBreeds[row]
		}

		requestDogImage()
	}
}
