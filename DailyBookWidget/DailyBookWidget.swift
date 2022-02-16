//
//  DailyBookWidget.swift
//  DailyBookWidget
//
//  Created by Daniel Slone on 15/2/22.
//

import WidgetKit
import SwiftUI
import Intents

struct DailyBookWidgetEntryView: View {
    var entry: BookProvider.Entry

    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: entry.image)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                Text(entry.authors)
            }
        }
        .padding([.top, .bottom], 8)
        .ignoresSafeArea()
    }
}

@main
struct DailyBookWidget: Widget {
    let kind: String = "DailyBookWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: BookProvider(booksFetchService: BooksFetchWorker())
        ) { entry in
            DailyBookWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Daily Book")
        .description("Shows daily recommended books")
    }
}
