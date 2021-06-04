//
//  Voucher.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

struct Voucher {
    let entryTime: Date
    let exitTime: Date
    let spotId: String
    let vehicleId: String
    let ticketId: String
    let fareDetails: FareDetails
}
