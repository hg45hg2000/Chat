//
//  ChatWidget.swift
//  ChatWidget
//
//  Created by HENRY on 2022/1/4.
//

import WidgetKit
import SwiftUI


struct ChatWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            Text(entry.date, style: .time)
            Text(entry.alert.title)
            Text(entry.alert.body)
        }
    }
}

@main
struct ChatWidget: Widget {
    let kind: String = "ChatWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ChatWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ChatWidget_Previews: PreviewProvider {
    static var previews: some View {
        ChatWidgetEntryView(entry: AlertEntry.mock()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
