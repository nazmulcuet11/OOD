//
//  FareCalculator.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 3/6/21.
//

import Foundation

protocol FareCalculator {
    func calculateFare(for ticket: Ticket) -> Fare
}
