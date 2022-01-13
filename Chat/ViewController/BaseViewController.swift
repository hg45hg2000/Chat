//
//  BaseViewController.swift
//  Chat
//
//  Created by HENRY on 2021/12/14.
//

import UIKit

class BaseViewController: UIViewController {

    let loadUI = LoadView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgourndColor
        // Do any additional setup after loading the view.
    }
    
    

}
