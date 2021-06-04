//
//  Spot.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 1/6/21.
//

import Foundation

enum SpotType: CaseIterable {
    case handicapped
    case electric
    case small
    case medium
    case large
}

class Spot {
    let id: String
    let level: Int
    let type: SpotType
    private var assignedVehicleId: String?

    var isFree: Bool {
        return assignedVehicleId == nil
    }

    init() {
        fatalError("Abstract class should not be instantiated")
    }

    @discardableResult
    func assignVehicle(vehicleId: String) -> Bool {
        guard isFree else {
            return false
        }

        assignedVehicleId = vehicleId
        return true
    }

    func removeVehicle() {
        assignedVehicleId = nil
    }
}
