//
//  URL+Extension.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/7/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Combine
import Foundation
import UIKit

extension URL {
    func image() -> AnyPublisher<UIImage, Error> {
        return Future { (promise) in
            DispatchQueue.global().async {
                guard let image = UIImage(contentsOfFile: self.path) else {
                    promise(.failure(.unableToFindCachedImage(self)))
                    return
                }
                
                promise(.success(image))
            }
        }
        .eraseToAnyPublisher()
    }
}
