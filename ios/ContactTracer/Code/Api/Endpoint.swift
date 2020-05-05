//
// Created by Leigh Williams on 2020-04-20.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation

public struct APIResponse: Codable {
    public var status: String

    public init(status: String) {
        self.status = status
    }
}

struct APIError: Error {
    let status: Int
    let message: String
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var fullURL: String { get }
    var method: HTTPMethod { get }
    var bodyData: Data? { get }
}

extension Endpoint {

    func execute<T: Codable>(completion: @escaping (T?) -> (), failure: @escaping (APIError) -> ()) -> Void {

        let url = URL(string: fullURL)!
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("API_KEY", forHTTPHeaderField: "x-functions-key")
        urlRequest.httpBody = bodyData

        let session = URLSession(configuration: URLSessionConfiguration.default)

        let task = session.dataTask(with: urlRequest) { data, response, error in

            guard error == nil else {
                failure(APIError(status: 500, message: error!.localizedDescription))
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                failure(APIError(status: 500, message: "No response"))
                return
            }
            guard 200..<300 ~= statusCode else {
                failure(APIError(status: statusCode, message: "API Request failed"))
                return
            }

            if let content = data,
               let payload = try? JSONDecoder().decode(T.self, from: content) {
                completion(payload)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
}
