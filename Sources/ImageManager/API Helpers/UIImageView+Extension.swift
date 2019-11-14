//
//  UIImageView+Extension.swift
//  Dummy
//
//  Created by Richard Blanchard on 11/8/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Combine
import Foundation
import UIKit

public extension UIImageView {
    func bindToURL(_ url: URL, storingIn subscriptions: inout Set<AnyCancellable>) {
        fetchImage(at: url)
            .sink(receiveCompletion: { (_) in
            }, receiveValue: { image in
                self.image = image
            })
            .store(in: &subscriptions)
    }
    
    func bindToURL(_ url: URL) -> AnyCancellable {
        fetchImage(at: url)
            .sink(receiveCompletion: { (_) in
            }, receiveValue: { image in
                self.image = image
            })
    }
}

private extension UIImageView {
    func fetchImage(at url: URL) -> AnyPublisher<UIImage, Error> {
        return ImageManager.default.fetchImage(at: url)
    }
}
