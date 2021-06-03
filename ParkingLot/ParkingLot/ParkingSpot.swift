//
//  ParkingSpot.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 1/6/21.
//

import Foundation

enum ParkingSpotType {
    case handicapped
    case compact
    case large
    case motorcycle
    case electric
}

class ParkingSpot {
    let id: String = UUID().uuidString
    let type: ParkingSpotType
    var isFree: Bool {
        assignedVehicle == nil
    }
    private var assignedVehicle: Vehicle?

    init() {
        fatalError("Abstract class should not be instantiated")
    }

    func assign(vehicle: Vehicle) -> Bool {
        guard isFree else {
            return false
        }

        assignedVehicle = vehicle
        return true
    }

    func free() {
        assignedVehicle = nil
    }
}
