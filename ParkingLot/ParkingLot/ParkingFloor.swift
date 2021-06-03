//
//  ParkingFloor.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 3/6/21.
//

import Foundation

final class ParkingFloor {
    let floorNumber: Int
    private(set) var allSpots: [ParkingSpot]

    init(
        floorNumber: Int,
        allSpots: [ParkingSpot] = []
    ) {
        self.floorNumber = floorNumber
        self.allSpots = allSpots
    }

    func addSpot(_ spot: ParkingSpot) {
        allSpots.append(spot)
    }

    func addSpots(_ spots: [ParkingSpot]) {
        allSpots.append(contentsOf: spots)
    }
}
