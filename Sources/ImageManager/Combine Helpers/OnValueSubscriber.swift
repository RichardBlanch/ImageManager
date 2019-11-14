//
//  OnValueSubscriber.swift
//  
//
//  Created by Richard Blanchard on 11/13/19.
//

import Combine
import Foundation

/// A subscriber that ignores completion emitted by a publisher. Only cares about the intermediate values received
final class OnValueSubscriber<Input, Failure: Swift.Error>: Subscriber, Cancellable {
    let combineIdentifier = CombineIdentifier()
    let receiveValue: (Input) -> Void
    private var subscription: Subscription? = nil
    
    init(receiveValue: @escaping (Input) -> Void) {
        self.receiveValue = receiveValue
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        receiveValue(input)
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        cancel()
    }
    
    func cancel() {
        subscription = nil
    }
}

extension Publisher {
    /// /// A subscriber that ignores completion emitted by a publisher. Only cares about the intermediate values received
    /// - Parameter receiveValue: Will call this closure when the publisher emits a value.
    func onValue(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        let subscriber = OnValueSubscriber<Self.Output, Self.Failure>(receiveValue: receiveValue)
        self.subscribe(subscriber)
        
        return AnyCancellable(subscriber)
    }
}
