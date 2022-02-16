//
//  BookEntry.swift
//  Books
//
//  Created by Daniel Slone on 15/2/22.
//

import Intents
import WidgetKit
import SwiftUI
import UIKit.UIImage

struct BookEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let title: String
    let authorsList: [String]
    let image: UIImage

    var authors: String {
        authorsList.joined(separator: ", ")
    }
}
