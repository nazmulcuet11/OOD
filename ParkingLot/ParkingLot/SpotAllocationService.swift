//
//  ParkingSpotRepository.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 3/6/21.
//

import Foundation

protocol SpotAllocationService {
    typealias ParkVehicleCallback = (Ticket?, Error?) -> Void
    typealias RemoveVechicleCallback = () -> Void

    func parkVehicle(_ vehicle: Vehicle, completion: ParkVehicleCallback)
    func removeVehicle(ticket: Ticket, completion: RemoveVechicleCallback)
}

class InMemorySoptAllocationServie {

}
