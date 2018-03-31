//
//  NetworkManager.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation

protocol NetworkManaging {
	func searchUsers(searchText: String, completion: @escaping ([User]) -> Void)
	func searchRepositories(searchText: String, completion: @escaping ([Repository]) -> Void)
	func getUserDetails(username: String, completion: @escaping (UserDetails) -> Void)
	func getUserStarredCount(username: String, completion: @escaping (Int?) -> Void)
}

struct ListResponse<T: Decodable>: Decodable {
	let total_count: Int
	let incomplete_results: Bool
	let items: [T]
}

class NetworkManager: NetworkManaging {
	
	// MARK: - Properties
	
	let session: URLSession
	var dataTaskUsers: URLSessionDataTask?
	var dataTaskRepositories: URLSessionDataTask?
	var dataTaskUserDetails: URLSessionDataTask?
	var dataTaskUserStarred: URLSessionDataTask?
	
	// MARK: - Initialization
	
	init() {
		session = URLSession.shared
	}
	
	// MARK: - Methods
	
	func searchUsers(searchText: String, completion: @escaping ([User]) -> Void) {
		dataTaskUsers?.cancel()
		guard var urlComponents = URLComponents(string: Endpoint.searchUsers.urlString) else { return }
		urlComponents.query = "q=\(searchText)"
		guard let url = urlComponents.url else { return }
		dataTaskUsers = session.dataTask(with: url, completionHandler: { (data, response, error) in
			defer { self.dataTaskUsers = nil }
			if let error = error {
				print(error.localizedDescription)
			} else if let data = data,
				let response = response as? HTTPURLResponse {
				if	response.statusCode == 200,
					let receivedObject = self.decodeJSON(data: data, toType: ListResponse<User>.self) {
					DispatchQueue.main.async {
						completion(receivedObject.items)
					}
				}
			}
		})
		dataTaskUsers?.resume()
	}
	
	func searchRepositories(searchText: String, completion: @escaping ([Repository]) -> Void) {
		dataTaskRepositories?.cancel()
		guard var urlComponents = URLComponents(string: Endpoint.searchRepositories.urlString) else { return }
		urlComponents.query = "q=\(searchText)"
		guard let url = urlComponents.url else { return }
		dataTaskRepositories = session.dataTask(with: url, completionHandler: { (data, response, error) in
			defer { self.dataTaskUsers = nil }
			if let error = error {
				print(error.localizedDescription)
			} else if let data = data,
				let response = response as? HTTPURLResponse {
				if	response.statusCode == 200,
					let receivedObject = self.decodeJSON(data: data, toType: ListResponse<Repository>.self) {
					DispatchQueue.main.async {
						completion(receivedObject.items)
					}
				}
			}
		})
		dataTaskRepositories?.resume()
	}
	
	func getUserDetails(username: String, completion: @escaping (UserDetails) -> Void) {
		dataTaskUserDetails?.cancel()
		let urlString = Endpoint.userDetails.urlString.replacingOccurrences(of: "{username}", with: username)
		guard let url = URL(string: urlString) else { return }
		dataTaskUserDetails = session.dataTask(with: url, completionHandler: { (data, response, error) in
			defer { self.dataTaskUserDetails = nil }
			if let error = error {
				print(error.localizedDescription)
			} else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200,
				let receivedObject = self.decodeJSON(data: data, toType: UserDetails.self) {
				DispatchQueue.main.async {
					completion(receivedObject)
				}
			}
		})
		dataTaskUserDetails?.resume()
	}
	
	func getUserStarredCount(username: String, completion: @escaping (Int?) -> Void) {
		dataTaskUserStarred?.cancel()
		let urlString = Endpoint.starred.urlString.replacingOccurrences(of: "{username}", with: username)
		guard let url = URL(string: urlString) else { return }
		dataTaskUserStarred = session.dataTask(with: url, completionHandler: { (data, response, error) in
			defer { self.dataTaskUserStarred = nil }
			if let error = error {
				print(error.localizedDescription)
				DispatchQueue.main.async {
					completion(nil)
				}
			} else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200,
				let receivedObject = self.decodeJSON(data: data, toType: Array<Repository>.self) {
				DispatchQueue.main.async {
					completion(receivedObject.count)
				}
			} else {
				DispatchQueue.main.async {
					completion(nil)
				}
			}
		})
		dataTaskUserStarred?.resume()
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
