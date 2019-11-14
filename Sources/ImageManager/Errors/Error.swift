//
//  Error.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/7/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
    case inherited(Swift.Error)
    case couldNotDownloadImage
    case couldNotCreateImage
    case couldNotCreateFileAtURL(URL)
    case couldNotRepresentURLAsData
    case couldNotHashURL
    case unableToFindCachedImage(URL)
    case urlError(URLError)
}
