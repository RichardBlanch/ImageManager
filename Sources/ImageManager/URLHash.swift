//
//  URLHash.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/8/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

protocol URLHash {
    /// Given a URL String. Hash to a new string. Should output to same string everytime fot same input.
    /// - Parameter urlString: The url you are going to hash.
    /// - Return: A Hashed URL
    func hashURLString(_ urlString: String) throws -> String
}

extension URLHash {
    func hashURL(_ url: URL) throws -> String {
        try hashURLString(url.path)
    }
}
