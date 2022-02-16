//
//  BooksFetchService.swift
//  Books
//
//  Created by Daniel Slone on 15/2/22.
//

import Foundation
import UIKit

public protocol BooksFetchService {
    typealias BooksResponse = Result<Books, Error>
    typealias BookImageResponse = Result<UIImage, Error>

    func fetchBooks(subject: Subject) async -> BooksResponse
    func fetchBooks(subject: Subject, completion: @escaping (BooksResponse) -> Void)
    func fetchBookImage(volumeInfo: VolumeInfo, completion: @escaping (BookImageResponse) -> Void)
}

public enum Subject: String {
    case horror

    public var queryValue: String {
        "subject:\(rawValue)"
    }
}
