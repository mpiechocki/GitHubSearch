//
//  NetworkManager.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol NetworkManaging {
	func searchUsers(searchText: String, completion: @escaping ([User]?) -> Void)
	func searchRepositories(searchText: String, completion: @escaping ([Repository]?) -> Void)
	func getUserDetails(username: String, completion: @escaping (UserDetails?) -> Void)
	func getUserStarredCount(username: String, completion: @escaping (Int?) -> Void)
	func getImage(url: String, completion: @escaping (UIImage?) -> Void)
}

struct ListResponse<T: Decodable>: Decodable {
	let total_count: Int
	let incomplete_results: Bool
	let items: [T]
}

class NetworkManager: NetworkManaging {
	
	// MARK: - Methods
	
	func searchUsers(searchText: String, completion: @escaping ([User]?) -> Void) {
		let parameters: Parameters = ["q": searchText]
		Alamofire.request(Endpoint.searchUsers.url, method: .get, parameters: parameters).responseJSON { [weak self] (response) in
			guard let `self` = self else { completion(nil); return }
			guard let statusCode = response.response?.statusCode else { completion(nil); return }
			guard statusCode == 200 else { completion(nil); return }
			guard let data = response.data else { completion(nil); return }
			guard let receivedObject = self.decodeJSON(data: data, toType: ListResponse<User>.self) else { completion(nil); return }
			completion(receivedObject.items)
		}
	}
	
	func searchRepositories(searchText: String, completion: @escaping ([Repository]?) -> Void) {
		let parameters: Parameters = ["q": searchText]
		Alamofire.request(Endpoint.searchRepositories.url, method: .get, parameters: parameters).responseJSON { [weak self] (response) in
			guard let `self` = self else { completion(nil); return }
			guard let statusCode = response.response?.statusCode else { completion(nil); return }
			guard statusCode == 200 else { completion(nil); return }
			guard let data = response.data else { completion(nil); return }
			guard let receivedObject = self.decodeJSON(data: data, toType: ListResponse<Repository>.self) else { completion(nil); return }
			completion(receivedObject.items)
		}
	}
	
	func getUserDetails(username: String, completion: @escaping (UserDetails?) -> Void) {
		let url = Endpoint.userDetails.url.replacingOccurrences(of: "{username}", with: username)
		Alamofire.request(url).responseJSON { [weak self] (response) in
			guard let `self` = self else { completion(nil); return }
			guard let statusCode = response.response?.statusCode else { completion(nil); return }
			guard statusCode == 200 else { completion(nil); return }
			guard let data = response.data else { completion(nil); return }
			guard let receivedObject = self.decodeJSON(data: data, toType: UserDetails.self) else { completion(nil); return }
			completion(receivedObject)
		}
	}
	
	func getUserStarredCount(username: String, completion: @escaping (Int?) -> Void) {
		let url = Endpoint.starred.url.replacingOccurrences(of: "{username}", with: username)
		Alamofire.request(url).responseJSON { [weak self] (response) in
			guard let `self` = self else { completion(nil); return }
			guard let statusCode = response.response?.statusCode else { completion(nil); return }
			guard statusCode == 200 else { completion(nil); return }
			guard let data = response.data else { completion(nil); return }
			guard let receivedObject = self.decodeJSON(data: data, toType: Array<Repository>.self) else { completion(nil); return }
			completion(receivedObject.count)
		}
	}
	
	func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
		Alamofire.request(url).responseImage { response in
			guard let data = response.data else { completion(nil); return }
			guard let statusCode = response.response?.statusCode else { completion(nil); return }
			guard statusCode == 200 else { completion(nil); return }
			guard let image = UIImage(data: data) else { completion(nil); return }
			completion(image)
		}
	}
	
	// MARK: - Helpers
	
	private func decodeJSON<T: Decodable>(data: Data, toType: T.Type) -> T? {
		let decoder = JSONDecoder()
		do {
			let response = try decoder.decode(T.self, from: data)
			return response
		}
		catch {
			print("There was a problem with json decoding: \(error)")
		}
		return nil
	}
}
