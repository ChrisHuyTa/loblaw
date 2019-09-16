//
//  UIImageView+.swift
//  LoblawSolution
//
//  Created by Chris Ta on 2019-09-13.
//  Copyright © 2019 Loblaw. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(from url: URL,
                   contentMode mode: UIView.ContentMode = .scaleAspectFill,
                   completion: ((_ image: UIImage) -> Void)? = nil) {
        contentMode = mode
        
        let cache = URLCache.shared
        let imgRequest = URLRequest(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let data = cache.cachedResponse(for: imgRequest)?.data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async() {
                    self.image = image
                    if let completion = completion {
                        completion(image)
                    }
                }
            } else {
                URLSession.shared.dataTask(with: imgRequest) { [weak self] data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    let cacheData = CachedURLResponse(response: httpURLResponse, data: data)
                    cache.storeCachedResponse(cacheData, for: imgRequest)
                    DispatchQueue.main.async() {
                        self?.image = image
                        if let completion = completion {
                            completion(image)
                        }
                    }
                    }.resume()
            }
            
        }
    }
    
}
