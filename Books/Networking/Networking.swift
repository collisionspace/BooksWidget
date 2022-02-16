//
//  Networking.swift
//  Networking
//
//  Created by Daniel Slone on 14/8/21.
//

import Foundation
import UIKit.UIImage

public final class Networking {

    public enum APIMethod: String {
        case get = "GET"
    }

    private static let imageCache = NSCache<NSString, UIImage>()

    /// Will fetch data from an `url` as long as the `generic T` conforms to a `Codable`
    /// - parameter url: String
    /// - parameter method: APIMethod
    /// - parameter parameters: [String: String]?
    /// - parameter completion: (Result<T, Error>) -> Void
    static func request<T: Codable>(url: URL?, method: APIMethod = .get, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
             completion(.failure(RequestError.invalidUrl))
            return
        }

        // Sets up the request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        // If any parameters has been passed in then attempt to serialize this
        // so it can be part of the request http body
        if let parameters = parameters,
           let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
            request.httpBody = httpBody
        }

        let session = URLSession.shared

        // Starts the actual fetch
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let response = try T(jsonData: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(RequestError.undefined))
            }
        }.resume()
    }

    /// Will fetch data from an `url` as long as the `generic T` conforms to a `Codable`
    /// - parameter url: String
    /// - parameter method: APIMethod
    /// - parameter parameters: [String: String]?
    /// - parameter headers: [String: String]?
    public static func request<T: Codable>(url: URL?, method: APIMethod = .get, parameters: [String: String]? = nil, headers: [String: String]? = nil) async -> Result<T, Error> {
        guard let url = url else {
             return .failure(RequestError.invalidUrl)
        }

        // Sets up the request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        // If any parameters has been passed in then attempt to serialize this
        // so it can be part of the request http body
        if let parameters = parameters,
           let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
            request.httpBody = httpBody
        }

        let session = URLSession.shared

        do {
            let (data, _) = try await session.data(for: request)
            let object = try T(jsonData: data)
            return .success(object)
        } catch {
            return .failure(error)
        }
    }

    /// Will download an image if its not already cached
    /// - parameter url: String
    /// - parameter completion: (Result<UIImage?, Error>) -> Void
    public static func downloadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let serviceUrl = URL(string: url) else {
            completion(.failure(RequestError.invalidUrl))
            return
        }
        if let cachedImage = imageCache.object(forKey: serviceUrl.absoluteString as NSString) {
            completion(.success(cachedImage))
        } else {
            let session = URLSession.shared
            session.dataTask(with: serviceUrl) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: serviceUrl.absoluteString as NSString)
                    completion(.success(image))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(RequestError.undefined))
                }
            }.resume()
        }
    }
}

private extension Decodable {
    /// Allows for decoding of data to be a bit more nicer and generic
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: jsonData)
    }
}
