//
//  Books.swift
//  Books
//
//  Created by Daniel Slone on 15/2/22.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let books = try? newJSONDecoder().decode(Books.self, from: jsonData)

import Foundation

// MARK: - Books
public struct Books: Codable {
    public let kind: String
    public let totalItems: Int
    public let items: [Item]
}

// MARK: - Item
public struct Item: Codable {
    public let kind: String
    public let id, etag: String
    public let selfLink: String
    public let volumeInfo: VolumeInfo
    public let saleInfo: SaleInfo
    public let accessInfo: AccessInfo
}

// MARK: - AccessInfo
public struct AccessInfo: Codable {
    public let country: String
    public let viewability: String
    public let embeddable, publicDomain: Bool
    public let textToSpeechPermission: String
    public let epub, pdf: Epub
    public let webReaderLink: String
    public let accessViewStatus: String
    public let quoteSharingAllowed: Bool
}

// MARK: - Epub
public struct Epub: Codable {
    public let isAvailable: Bool
}

// MARK: - SaleInfo
public struct SaleInfo: Codable {
    public let country: String
    public let saleability: String
    public let isEbook: Bool
}

// MARK: - VolumeInfo
public struct VolumeInfo: Codable {
    public let title: String
    public let authors: [String]
    public let publishedDate: String
    public let volumeInfoDescription: String?
    public let industryIdentifiers: [IndustryIdentifier]
    public let readingModes: ReadingModes
    public let pageCount: Int
    public let printType: String
    public let categories: [String]?
    public let maturityRating: String
    public let allowAnonLogging: Bool
    public let contentVersion: String
    public let imageLinks: ImageLinks?
    public let language: String
    public let previewLink, infoLink: String
    public let canonicalVolumeLink: String
    public let subtitle, publisher: String?
    public let averageRating: Double?
    public let ratingsCount: Int?
    public let panelizationSummary: PanelizationSummary?

    enum CodingKeys: String, CodingKey {
        case title, authors, publishedDate
        case volumeInfoDescription = "description"
        case industryIdentifiers, readingModes, pageCount, printType, categories, maturityRating, allowAnonLogging, contentVersion, imageLinks, language, previewLink, infoLink, canonicalVolumeLink, subtitle, publisher, averageRating, ratingsCount, panelizationSummary
    }
}

// MARK: - ImageLinks
public struct ImageLinks: Codable {
    public let smallThumbnail: String?
    public let thumbnail: String?
    public let small: String?
    public let medium: String?
    public let large: String?
    public let extraLarge: String?
}

// MARK: - IndustryIdentifier
public struct IndustryIdentifier: Codable {
    public let type: String
    public let identifier: String
}

// MARK: - PanelizationSummary
public struct PanelizationSummary: Codable {
    public let containsEpubBubbles, containsImageBubbles: Bool
}

// MARK: - ReadingModes
public struct ReadingModes: Codable {
    public let text, image: Bool
}
