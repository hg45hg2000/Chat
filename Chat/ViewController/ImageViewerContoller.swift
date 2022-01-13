//
//  ImageViewerContoller.swift
//  Chat
//
//  Created by HENRY on 2021/12/26.
//

import UIKit
import SnapKit
class ImageViewerContoller: BaseViewController {

    let imageView = UIImageView()
    
    let closeButton = UIButton(type: .close)
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(closeButton)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.center.equalTo(scrollView)
            make.height.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        closeButton.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
  
        closeButton.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView).multipliedBy(0.2)
            make.centerY.equalTo(scrollView).multipliedBy(0.1)
        }
        scrollView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(view)
            make.width.equalTo(view)
        }
        scrollView.maximumZoomScale = 10.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    @objc func closeViewController(){
        dismiss(animated: true, completion: nil)
    }
}
extension ImageViewerContoller:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
