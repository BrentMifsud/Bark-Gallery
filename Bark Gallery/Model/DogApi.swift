//
//  DogApi.swift
//  Bark Gallery
//
//  Created by Brent Mifsud on 2019-05-12.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import UIKit

class DogApi {
	enum Endpoints: String {
		case randomDogImage = "https://dog.ceo/api/breeds/image/random"
		case listAllBreeds = "https://dog.ceo/api/breeds/list/all"

		var url: URL {
			return URL(string: self.rawValue)!
		}
	}


	class func requestAllBreeds(completionHandler: @escaping (DogApiResponse?, Error?) -> Void){
		let listAllBreedsEndpoint = DogApi.Endpoints.listAllBreeds.url

		let task = URLSession.shared.dataTask(with: listAllBreedsEndpoint) { (data, response, error) in

			guard let data = data else {
				completionHandler(nil, error)
				return
			}

			let jsonDecoder = JSONDecoder()

			do {
				let breedData = try jsonDecoder.decode(DogApiResponse.self, from: data)

				completionHandler(breedData, nil)
			} catch {
				print("Unable to decode JSON")
			}
		}
		task.resume()
	}


	class func requestRandomImage(completionHandler: @escaping (DogApiResponse?, Error?) -> Void) {
		let randomImageEndpoint = DogApi.Endpoints.randomDogImage.url

		let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in

			guard let data = data else {
				completionHandler(nil, error)
				return
			}

			let jsonDecoder = JSONDecoder()

			do {
				let imageData = try jsonDecoder.decode(DogApiResponse.self, from: data)

				completionHandler(imageData, nil)
			} catch {
				print("Unable to decode JSON")
			}
		}
		task.resume()
	}


	class func requestDogImage(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
		let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

			guard let data = data else {
				completionHandler(nil, error)
				return
			}

			let downloadedImage = UIImage(data: data)

			completionHandler(downloadedImage, nil)

		})
		task.resume()
	}

}
