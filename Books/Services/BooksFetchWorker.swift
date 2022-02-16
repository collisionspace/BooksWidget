//
//  BooksFetchWorker.swift
//  Books
//
//  Created by Daniel Slone on 15/2/22.
//

import Foundation

public struct BooksFetchWorker: BooksFetchService {

    private var endpoint: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.googleapis.com"
        urlComponents.path = "/books/v1/volumes"
        return urlComponents
    }

    public func fetchBooks(subject: Subject) async -> BooksResponse {
        await Networking.request(
            url: endpoint.constructFetchBook(subject: subject).url
        )
    }

    public func fetchBooks(subject: Subject, completion: @escaping (BooksResponse) -> Void) {
        Networking.request(url: endpoint.constructFetchBook(subject: subject).url) { (result: BooksResponse) in
            completion(result)
        }
    }

    public func fetchBookImage(volumeInfo: VolumeInfo, completion: @escaping (BookImageResponse) -> Void) {
        Networking.downloadImage(url: volumeInfo.imageUrl) { result in
            completion(result)
        }
    }
}

private extension URLComponents {
    func constructFetchBook(subject: Subject) -> URLComponents {
        var components = self
        components.queryItems = [
            URLQueryItem(name: "q", value: subject.queryValue),
            startIndexQueryItem
        ]
        return components
    }

    var startIndexQueryItem: URLQueryItem {
        // To get a more randomness in what book is picked, this will go up to 190
        // as for the subject I picked has up to 200 items and returns in 10 item chunks
        URLQueryItem(name: "startIndex", value: "\(Int.random(in: 0..<19) * 10)")
    }
}

private extension VolumeInfo {
    var imageUrl: String {
        if let thumbnail = imageLinks?.smallThumbnail {
            return thumbnail
        } else if let thumbnail = imageLinks?.thumbnail {
            return thumbnail
        } else if let thumbnail = imageLinks?.small {
            return thumbnail
        } else if let thumbnail = imageLinks?.medium {
            return thumbnail
        } else if let thumbnail = imageLinks?.large {
            return thumbnail
        } else if let thumbnail = imageLinks?.extraLarge {
            return thumbnail
        }
        return ""
    }
}
