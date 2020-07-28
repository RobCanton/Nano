//
//  UIImageView+Extensions.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response ,error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
    
    
}


enum FileSource {
    case cache
    case network
}

class ImageManager {
    
    
    static let imageCache = NSCache<NSString,UIImage>()
    
    static func fetchImage(from url: URL, completion: @escaping (_ url:URL, _ source:FileSource, _ image:UIImage?)->()) {
        if let image = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            return completion(url, .cache, image)
        } else {
            return downloadImage(from: url, completion: completion)
        }
    }
    static func downloadImage(from url: URL, completion: @escaping (_ url:URL, _ source:FileSource, _ image:UIImage?)->()) {
        URLSession.shared.dataTask(with: url) { data, response ,error in
            var image:UIImage?
            if let data = data {
                image = UIImage(data: data)
            }
            
            if image != nil {
                imageCache.setObject(image!, forKey: NSString(string: url.absoluteString))
            }
            
            DispatchQueue.main.async {
                completion(url, .network, image)
            }
        }.resume()
    }
}
