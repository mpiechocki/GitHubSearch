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

struct SearchResponse: Decodable {
	let total_count: Int
	let incomplete_results: Bool
	let items: [User]
}

class NetworkManager: NetworkManaging {
	
	// MARK: - Properties
	
	let session: URLSession
	var dataTask: URLSessionDataTask?
	
	// MARK: - Initialization
	
	init() {
		session = URLSession(configuration: .default)
	}
	
	// MARK: - Methods
	
	func search(searchText: String, completion: @escaping ([TableViewItem]) -> Void) {
		dataTask?.cancel()
		guard var urlComponents = URLComponents(string: Endpoint.searchUsers.urlString) else { return }
		urlComponents.query = "q=\(searchText)"
		guard let url = urlComponents.url else { return }
		dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
			defer { self.dataTask = nil }
			if let error = error {
				print(error.localizedDescription)
			} else if let data = data,
				let response = response as? HTTPURLResponse {
				if
					response.statusCode == 200,
					let receivedObject = self.decodeJSON(data: data, toType: SearchResponse.self) {
					completion(receivedObject.items.map { TableViewItem.user(user: $0) })
				}
			}
		})
		dataTask?.resume()
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
