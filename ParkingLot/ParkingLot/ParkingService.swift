//
//  ParkingService.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

struct ParkingRequest {
    var vehicleId: String
    var entranceId: String
    var allowedSpotTypes: [SpotType]
}

protocol ParkingService {
    typealias EntryCompletion = (Result<Ticket, Error>) -> Void
    typealias ReleaseCompletion = (Result<Voucher, Error>) -> Void

    func entry(_ request: ParkingRequest, completion:  @escaping EntryCompletion)
    func release(_ ticketId: String, paymentStrategy: PaymentStrategy, completion: @escaping ReleaseCompletion)
}
