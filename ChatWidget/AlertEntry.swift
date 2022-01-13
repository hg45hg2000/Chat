//
//  AlertEntry.swift
//  ChatWidgetExtension
//
//  Created by HENRY on 2022/1/4.
//

import WidgetKit

struct AlertEntry: TimelineEntry{
    let date: Date
    let alert: AlertModel
    static func mock()->AlertEntry{
        return AlertEntry(date: Date(), alert: AlertModel(title: "test", body: "test"))
    }
}
