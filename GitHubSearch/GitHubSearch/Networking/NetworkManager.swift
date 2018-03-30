//
//  NetworkManager.swift
//  GitHubSearch
//
//  Created by dontgonearthecastle on 30/03/2018.
//  Copyright © 2018 dontgonearthecastle. All rights reserved.
//

import Foundation

protocol NetworkManaging {
	func search(searchText: String, completion: @escaping ([TableViewItem]) -> Void)
}

struct Response<T: Decodable>: Decodable {
	let total_count: Int
	let incomplete_results: Bool
	let items: [T]
}

class NetworkManager: NetworkManaging {
	
	// MARK: - Properties
	
	let session: URLSession
	var dataTaskUsers: URLSessionDataTask?
	var dataTaskRepositories: URLSessionDataTask?
	
	// MARK: - Initialization
	
	init() {
		session = URLSession(configuration: .default)
	}
	
	// MARK: - Methods
	
	func search(searchText: String, completion: @escaping ([TableViewItem]) -> Void) {
		searchUsers(searchText: searchText) { (users) in
			completion(users.map { TableViewItem.user(user: $0) })
		}
		searchRepositories(searchText: searchText) { (repositories) in
			completion(repositories.map { TableViewItem.repository(repository: $0) })
		}
	}
	
	// @TODO: powiązać endpoint z modelem? Żeby załatwić te dwie metody jedną generyczną?
	
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
					let receivedObject = self.decodeJSON(data: data, toType: Response<User>.self) {
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
					let receivedObject = self.decodeJSON(data: data, toType: Response<Repository>.self) {
					DispatchQueue.main.async {
						completion(receivedObject.items)
					}
				}
			}
		})
		dataTaskRepositories?.resume()
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
