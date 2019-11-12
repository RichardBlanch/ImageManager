//
//  Combine+Extension.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/8/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Combine
import Foundation
import UIKit

extension Publisher where Self.Output == Data  {
    func createImage() -> AnyPublisher<UIImage, Error> {
        return tryMap { data -> UIImage in
            guard let image = UIImage(data: data) else {
                throw Error.couldNotCreateImage
            }
            
            return image
        }
        .mapStandardError()
    }
}

extension Publisher where Self.Failure == Swift.Error {
    func mapStandardError() -> AnyPublisher<Self.Output, Error> {
        self.mapError { error -> Error in
            if let error = error as? Error {
                return error
            } else if let urlError = error as? URLError {
                return Error.urlError(urlError)
            } else {
                return Error.inherited(error)
            }
        }.eraseToAnyPublisher()
    }
}

extension Publisher where Self.Output == UIImage {
    func moveImage(from remoteURL: URL, using localURLHelper: LocalURLHelper) -> AnyPublisher<CachedImage, Error> {
        tryMap {
            try localURLHelper.addImageToDirectory(image: $0, from: remoteURL)
        }
        .mapStandardError()
        .eraseToAnyPublisher()
    }
    
    func writeImageToCache(for key: URL, cacher: ImageCacher) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveOutput: { [cacher] image in
            cacher.cacheImage(image, at: key)
        })
        .eraseToAnyPublisher()
    }
}

extension Publisher where Self.Output == CachedImage {
    func writeDownloadedImageToCache(_ cacher: ImageCacher) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveOutput: { [cacher] cachedImage in
            cacher.cacheDownloadedImage(cachedImage)
        })
        .eraseToAnyPublisher()
    }
}
