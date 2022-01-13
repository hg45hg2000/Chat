//
//  Provider.swift
//  ChatWidgetExtension
//
//  Created by HENRY on 2022/1/4.
//

import WidgetKit

struct Provider: TimelineProvider {
    
    typealias Entry = AlertEntry
    
    func placeholder(in context: Context) -> AlertEntry {
        AlertEntry.mock()
    }

    func getSnapshot(in context: Context, completion: @escaping (AlertEntry) -> ()) {
  
        completion(AlertEntry.mock())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let userDefaults = UserDefaults(suiteName: "group.chat.togethe")
        guard let dict = userDefaults?.string(forKey: "alertContent") else {
            return
        }
        
        let currentDate = Date()
        let entry = AlertEntry(date: currentDate, alert: AlertModel(title: dict, body: ""))
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}
