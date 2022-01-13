//
//  ImageCollectionViewCell.swift
//  Chat
//
//  Created by HENRY on 2021/12/9.
//

import UIKit
import SnapKit
class ImageCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
