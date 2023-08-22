//
//  ImageUtils.swift
//  Laza
//
//  Created by Dimas Wisodewo on 22/08/23.
//

import UIKit

class ImageUtils {
    static let shared = ImageUtils()

    func resize(image: UIImage, size: CGSize) -> UIImage{
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { context in
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        return resizedImage
    }
}
