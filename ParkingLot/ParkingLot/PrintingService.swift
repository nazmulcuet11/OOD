//
//  PrintingService.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

protocol PrintingService {
    func printTicket(_ ticket: Ticket)
    func printVoucher(_ voucher: Voucher)
    func printError(_ error: Error)
}
