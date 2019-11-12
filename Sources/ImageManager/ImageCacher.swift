//
//  ImageCacher.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/7/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit

class ImageCacher {

    private lazy var cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.name = "com.cache." + String(describing: type(of: self))

        return cache
    }()
    
    func cacheDownloadedImage(_ cachedImage: CachedImage) {
        cacheImage(cachedImage.image, at: cachedImage.url)
    }
    
    func cacheImage(_ image: UIImage, at url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    func readImage(at url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
}
#endif


