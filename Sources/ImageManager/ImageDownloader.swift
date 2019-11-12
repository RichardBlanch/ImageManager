//
//  ImageDownloader.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/7/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

#if os(iOS)
import Combine
import Foundation
import UIKit

class ImageDownloader {
    
    private let urlSession: URLSession
    private let localURLHelper: LocalURLHelper
    
    init(urlSession: URLSession, localURLHelper: LocalURLHelper) {
        self.urlSession = urlSession
        self.localURLHelper = localURLHelper
    }
    
    /// Downloads a remote image at a URL.
    /// - Parameter url: The remote URL of the image you want to download
    /// - Returns: A publisher of a CachedImage (an image with a local URL)
    func downloadImage(for url: URL) -> AnyPublisher<CachedImage, Error> {
        urlSession.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .map(\.data)
            .createImage()
            .moveImage(from: url, using: localURLHelper)
            .retry(3)
            .eraseToAnyPublisher()
    }
}
#endif
