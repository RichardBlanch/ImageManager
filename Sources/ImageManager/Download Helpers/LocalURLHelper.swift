//
//  LocalURLHelper.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/7/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//


import Foundation
import UIKit

class LocalURLHelper {
    private let fileManager: FileManager
    private let directoryToSave: URL
    private let hasher: URLHash
    
    init(fileManager: FileManager, directoryToSave: URL, hasher: URLHash) {
        self.fileManager = fileManager
        self.directoryToSave = directoryToSave
        self.hasher = hasher
    }
    
    func doesURLExist(_ url: URL) -> Bool {
        fileManager.fileExists(atPath: url.path)
    }
    
    func addImageToDirectory(_ image: UIImage, from remoteURL: URL) throws -> CachedImage {
        let createImageAtHashedURL = try self.createImageAtHashedURL(at: remoteURL, with: image)
        return CachedImage(image: image, url: createImageAtHashedURL)
    }
    
    func getHashedURL(from remoteURL: URL) throws -> URL? {
        let hashedURLString = try getHashedURLString(remoteURL)
        return URL(fileURLWithPath: hashedURLString, relativeTo: directoryToSave).appendingPathExtension("png")
    }
    
    func createImageAtHashedURL(at remoteURL: URL, with image: UIImage) throws -> URL {
        let hashedURL = try getHashedURLString(remoteURL)
        let url = URL(fileURLWithPath: hashedURL, relativeTo: directoryToSave).appendingPathExtension("png")

        let didCreateFile = fileManager.createFile(atPath: url.path, contents: image.pngData(), attributes: nil)
        
        if !didCreateFile {
            throw Error.couldNotCreateFileAtURL(url)
        }
        
        return url
    }
    
    private func getHashedURLString(_ url: URL) throws -> String {
        try hasher.hashURL(url)
    }
}

