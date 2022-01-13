//
//  LoadView.swift
//  Chat
//
//  Created by HENRY on 2021/12/18.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

class LoadView: UIView {
    
    let loadUI = NVActivityIndicatorView(frame: CGRect.zero, type: .ballClipRotate, color: .white, padding: 1.0)

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .black
        alpha = 0.6
        addSubview(loadUI)
        loadUI.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(loadUI.snp.height).multipliedBy(1)
            make.width.equalTo(100)
        }
    }
    func showLoadUI(){
        UIApplication.shared.windows.first?.addSubview(self)
        loadUI.startAnimating()
    }
    func stopLoadUI(){
        removeFromSuperview()
        loadUI.stopAnimating()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
