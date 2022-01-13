//
//  Date+Extension.swift
//  Chat
//
//  Created by HENRY on 2021/12/20.
//

import Foundation

extension Date{
    func covertToString()->String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH-mm"
        return formatter.string(from: self)
    }
}
