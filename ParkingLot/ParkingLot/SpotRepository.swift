//
//  SpotRepository.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

protocol SpotRepositoryObserver {
    func spotAdded(_ repository: SpotRepository, spot: Spot)
    func spotUpdated(_ repository: SpotRepository, spot: Spot)
    func spotRemoved(_ repository: SpotRepository, spot: Spot)
}

protocol SpotStore {
    @discardableResult func add(_ spot: Spot) -> Bool
    @discardableResult func update(_ spot: Spot) -> Bool
    @discardableResult func remove(_ spot: Spot) -> Bool
    func getSpot(spotId: String) -> Spot?
}

class SpotRepository: SubscribableService {
    var weakSubscribers: [String : Weak<SpotRepositoryObserver>] = [:]

    private let store: SpotStore

    init(store: SpotStore) {
        self.store = store
    }

    @discardableResult
    func save(_ spot: Spot) -> Bool {
        if getSpot(spotId: spot.id) == nil {
            return addSpot(spot)
        } else {
            return updateSpot(spot)
        }
    }

    @discardableResult
    func remove(_ spot: Spot) -> Bool {
        guard getSpot(spotId: spot.id) != nil else {
            return false
        }

        let success = store.remove(spot)
        if success {
            notifySubscribers { $0.spotRemoved(self, spot: spot) }
        }
        return success
    }

    func getSpot(spotId: String) -> Spot? {
        return store.getSpot(spotId: spotId)
    }

    // MARK: - Helpers

    private func addSpot(_ spot: Spot) -> Bool {
        let success = store.add(spot)
        if success {
            notifySubscribers { $0.spotAdded(self, spot: spot) }
        }
        return success
    }

    private func updateSpot(_ spot: Spot) -> Bool {
        let success = store.update(spot)
        if success {
            notifySubscribers { $0.spotUpdated(self, spot: spot) }
        }
        return success
    }
}
