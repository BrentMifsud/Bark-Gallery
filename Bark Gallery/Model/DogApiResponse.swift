//
//  DogImage.swift
//  Bark Gallery
//
//  Created by Brent Mifsud on 2019-05-14.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

// For use with Random Dog Image and Dog Breeds List Requests
struct DogApiResponse: Codable{
	let status: String
	let message: String
}
