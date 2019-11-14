//
//  ImageManager.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/7/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Combine
import Foundation
import UIKit

/// A class that will fetch cached images or download them for the server.
public class ImageManager {
    private let localURLHelper: LocalURLHelper
    private let cacher = ImageCacher()
    private let downloader: ImageDownloader
    
    public static let `default` = ImageManager(urlSession: URLSession.shared, fileManager: FileManager.default)
    
    public static func cachedImageDirectory() -> URL {
        let fileManager = FileManager.default
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageDirectory = URL(fileURLWithPath: "Images", isDirectory: true, relativeTo: cacheDirectory)
        
        if !fileManager.fileExists(atPath: imageDirectory.path) {
            try! fileManager.createDirectory(at: imageDirectory, withIntermediateDirectories: false, attributes: nil)
        }
        
        return imageDirectory
    }
    
    public init(urlSession: URLSession, fileManager: FileManager, directoryToSave: URL = ImageManager.cachedImageDirectory()) {
        self.localURLHelper = LocalURLHelper(fileManager: fileManager,
                                             directoryToSave: directoryToSave,
                                             hasher: SHA256KeepingLowerCaseLettersHash())

        self.downloader = ImageDownloader(urlSession: urlSession, localURLHelper: localURLHelper)
    }
    
    public func fetchImages(at urls: [URL]) -> AnyPublisher<[UIImage], Error> {
        guard !urls.isEmpty else {
            return Empty<[UIImage], Error>().eraseToAnyPublisher()
        }
        
        let initialPublisher = fetchImage(at: urls[0])
        let remainder = Array(urls.dropFirst())
        
        return remainder.reduce(initialPublisher) { (combinedPublishers, nextURL) -> AnyPublisher<UIImage, Error> in
            return combinedPublishers.merge(with: fetchImage(at: nextURL)).eraseToAnyPublisher()
        }
        .collect()
        .eraseToAnyPublisher()
    }
    
    /// Fetches a cached instance of an image for a given url or downloads that image from a remote URL.
    /// - Parameter url: The Remote URL for the image you would like to recieve.
    public func fetchImage(at remoteURL: URL) -> AnyPublisher<UIImage, Error> {
        guard let createImageAtHashedURL = hashedFileURL(for: remoteURL) else {
            return downloadImage(at: remoteURL).receive(on: DispatchQueue.main).eraseToAnyPublisher()
        }
        
        return fetchCachedImage(at: createImageAtHashedURL).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    /// If this method returns a non-nil url then we have already fetched this URL. The hashed version of this URL will be in our user's directory or our cache.
    /// - Parameter url: The URL that was fetched from the server. The hashed version of this url may be cached and will be returned in this method if it is.
    private func hashedFileURL(for remoteURL: URL) -> URL? {
        guard let createImageAtHashedURL = try? localURLHelper.getHashedURL(from: remoteURL) else {
            return nil
        }
        
        let doesHashedFileURLExist = localURLHelper.doesURLExist(createImageAtHashedURL)
        
        return doesHashedFileURLExist ? createImageAtHashedURL : nil
    }
    
    /// Downloads an image from a remote URL.
    /// - Parameter url: The remote URL you would like to download.
    private func downloadImage(at url: URL) -> AnyPublisher<UIImage, Error> {
        return downloader
            .downloadImage(for: url)
            .writeDownloadedImageToCache(cacher)
            .map(\.image)
            .eraseToAnyPublisher()
    }
    
    /// Located a cached image within your cache or the user's directory. Should *never* return nil
    /// - Parameter url: The hashed URL of your remote URL for the image which you downloaded
    private func fetchCachedImage(at hashedURL: URL) -> AnyPublisher<UIImage, Error> {
        guard let cachedImage = cacher.readImage(at: hashedURL) else {
            // Fetch image from directory
            return hashedURL.image()
                .writeImageToCache(for: hashedURL, cacher: cacher)
                .eraseToAnyPublisher()
        }
        
        return Publishers.convertToPublisher(type: cachedImage)
    }
}


// MARK: - Constant

private extension ImageManager {
    struct Constant: RawRepresentable {
        typealias RawValue = String
        var rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        
        static let Images = Constant(rawValue: "Images")
    }
}
