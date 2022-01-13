//
//  UIAlertViewController.swift
//  Chat
//
//  Created by HENRY on 2021/11/24.
//

import Foundation
import UIKit
extension UIAlertController{
    static func showAlert(in viewController: UIViewController?, withTitle title: String){
        let controller = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in
            controller.dismiss(animated: true, completion: nil)
        }))
        viewController?.present(controller, animated: true, completion: nil)
    }
}

struct Tool {
    func confirmAction(in viewController: UIViewController, withTitle title: String, andPlaceholders placeHolders: [String],completionHandler: @escaping (Bool, [String]?) -> Void){
        //利用title生成UIAlertController
        let controller = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        //利用placeholder陣列來加入UIAlertController的text field
        for placeholder in placeHolders {
            controller.addTextField { (textField) in
            textField.placeholder = placeholder
            }
        }
        //如果使用者點擊確定，就會將textFiled的值轉成input回傳
        controller.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            var inputs = [String]()
            guard let textFields = controller.textFields else {return}
            for textField in textFields {
            inputs.append(textField.text!)
            }
            completionHandler(true, inputs)
        }))
        //如果點擊取消，就dismiss
        controller.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            completionHandler(false, nil)
        }))
        viewController.present(controller, animated: true, completion: nil)
        }
}
