//
//  Vehicle.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 1/6/21.
//

import Foundation

enum VehicleType {
    case car
    case truck
    case electric
    case van
    case motorcycle
}

protocol Vehicle {
    var type: VehicleType { get }
    var id: String { get }
}
