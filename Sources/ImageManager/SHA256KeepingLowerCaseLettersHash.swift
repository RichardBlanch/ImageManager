//
//  SHA256KeepingLowerCaseLettersHash.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/8/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import CryptoKit
import Foundation

struct SHA256KeepingLowerCaseLettersHash: URLHash {
    func hashURLString(_ urlString: String) throws -> String {
        guard let data = urlString.data(using: .utf8) else {
            throw Error.couldNotRepresentURLAsData
        }

        let hash = SHA256.hash(data: data)
        let bytes = hash.makeIterator().compactMap { $0 }
        let hashedString = Data(bytes: bytes, count: bytes.count).base64EncodedString()
        let lowerCaseHashedSolelyLetterString = hashedString.lowercased().filter { $0.isLetter }
        
        return lowerCaseHashedSolelyLetterString
    }
}
