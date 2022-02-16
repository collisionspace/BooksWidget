//
//  BookProvider.swift
//  Books
//
//  Created by Daniel Slone on 15/2/22.
//

import WidgetKit
import UIKit.UIImage
import Intents

struct BookProvider: IntentTimelineProvider {

    private let booksFetchService: BooksFetchService

    init(booksFetchService: BooksFetchService) {
        self.booksFetchService = booksFetchService
    }

    func placeholder(in context: Context) -> BookEntry {
        BookEntry(date: Date(), configuration: ConfigurationIntent(), title: "", authorsList: [], image: UIImage())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (BookEntry) -> ()) {
        let entry = BookEntry(date: Date(), configuration: ConfigurationIntent(), title: "", authorsList: [], image: UIImage())
        completion(entry)
    }

    // no way to support await/async stuff inside of here
    //
    // api is called twice in a row, from searching google it seems to be an apple issue
    //
    // can only download images as well in here, can't use AsyncImage or an alternative in the SwiftUI view
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<BookEntry>) -> ()) {
        booksFetchService.fetchBooks(subject: .horror) { result in
            guard case let .success(response) = result,
                let book = response.items.first else {
                    return
            }
            let volumeInfo = book.volumeInfo
            booksFetchService.fetchBookImage(volumeInfo: volumeInfo) { imageResult in
                guard case let .success(image) = imageResult else {
                    return
                }
                let entry = BookEntry(
                    date: Date(),
                    configuration: ConfigurationIntent(),
                    title: book.volumeInfo.title,
                    authorsList: book.volumeInfo.authors,
                    image: image
                )
                let timeline = Timeline(entries: [entry], policy: .oneDayLater)
                completion(timeline)
            }
        }
    }
}

private extension TimelineReloadPolicy {
    static let oneDayLater: TimelineReloadPolicy = .after(.now + 86400)
}
