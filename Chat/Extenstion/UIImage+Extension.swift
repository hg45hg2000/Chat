//
//  UIImage+Extension.swift
//  Chat
//
//  Created by HENRY on 2021/12/14.
//

import Foundation
import UIKit

extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: canvas, format: format).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: width)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
