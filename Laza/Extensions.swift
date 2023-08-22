//
//  Extensions.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

extension UIImage {
    // This method creates an image of a view
    convenience init?(view: UIView) {
        
        // Based on https://stackoverflow.com/a/41288197/1118398
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
        
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
    
}

extension UIImageView {
    
    func loadAndCache(url: String, cache: URLCache? = nil, placeholder: UIImage? = nil) {
            
            guard let url = URL(string: url) else {
                return
            }
        
            var request = URLRequest(url: url)
        
            let cache = cache ?? URLCache.shared
        
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                self.image = image
            } else {
                request.httpMethod = "GET"
                
                NetworkManager.shared.sendRequest(request: request) { result in
                    switch result {
                    case .success(let passedData):
                        let data = passedData.0
                        let response = passedData.1
                        if let unwrappedData = data, let unwrappedResponse = response {
                            let cachedData = CachedURLResponse(response: unwrappedResponse, data: unwrappedData)
                            cache.storeCachedResponse(cachedData, for: request)
                            DispatchQueue.main.async { [weak self] in
                                self?.image = UIImage(data: unwrappedData)
                            }
                        } else {
                            print("Failed to unwrap data and response")
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
}

extension String {
    
    func formatDecimal() -> String {
        var text = self
        if self.hasSuffix(".0") {
            let start = self.index(self.endIndex, offsetBy: -2)
            let end = self.endIndex
            text.removeSubrange(start..<end)
        }
        return text
    }
}

/// CATransaction enables to create completion block which no matter the numbers of animation change is running or various combination of animation timings, completion block will be called when all animation changes has finishing performing.
/// based on https://padamthapa.com/blog/adding-completion-block-for-popviewcontroller/
extension UINavigationController {
    
    func popViewControllerWithHandler(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewControllerWithHandler(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: animated)
        CATransaction.commit()
    }

    func pushViewController(viewController: UIViewController, animated:Bool = true,  completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

extension Notification.Name {
    static var newReviewAdded: Notification.Name {
        return .init("ProductDetail.newReviewAdded")
    }
    static var profileUpdated: Notification.Name {
        return .init("Profile.profileUpdated")
    }
    static var wishlistUpdated: Notification.Name {
        return .init("Wishlist.wishlistUpdated")
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
