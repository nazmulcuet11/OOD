//
//  Obserable.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

struct Weak<T> {
    private weak var _reference: AnyObject?

    init(_ object: T) {
        _reference = object as AnyObject
    }
    var reference: T? { _reference as? T }
}

class CancellableSubscription {
    typealias OnCancelCallback = () -> Void

    private let onCancel: OnCancelCallback

    init(onCancel: @escaping OnCancelCallback) {
        self.onCancel = onCancel
    }

    deinit {
        cancel()
    }

    func cancel() {
        onCancel()
    }
}

protocol SubscribableService: class {
    associatedtype Subscriber

    var weakSubscribers: [String: Weak<Subscriber>] { get set }

    func subscribe(_ subscriber: Subscriber) -> CancellableSubscription
}

extension SubscribableService {
    func subscribe(_ subscriber: Subscriber) -> CancellableSubscription {
        let token = UUID().uuidString
        let weakSubscriber = Weak(subscriber)
        weakSubscribers[token] = weakSubscriber
        print("Added subscriber for token: \(token)")
        let subscription = CancellableSubscription(onCancel: {
            // be cautious about what you capture here
            // capturing self or subscriber strongly will cause a memory leak
            [weak self] in
            self?.weakSubscribers.removeValue(forKey: token)
            print("Removed subscriber for token: \(token)")
        })
        return subscription
    }

    func notifySubscribers(_ notificationTask: (Subscriber) -> Void) {
        let subscribers = weakSubscribers.values.compactMap({ $0.reference })
        for subscriber in subscribers {
            notificationTask(subscriber)
        }
    }
}
