//
//  AlertModel.swift
//  ChatWidgetExtension
//
//  Created by HENRY on 2022/1/4.
//

import Foundation

struct AlertModel{
    let title: String
    let body: String
    init(dict:Dictionary<String,Any>){
        title = dict["title"] as! String
        body = dict["body"] as! String
    }
    init(title: String,body: String){
        self.title = title
        self.body = body
    }
}
