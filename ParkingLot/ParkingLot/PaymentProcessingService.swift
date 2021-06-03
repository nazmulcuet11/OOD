//
//  PaymentProcessingService.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 3/6/21.
//

import Foundation
import Combine

class PaymentProcessingService {
    typealias ReceivePaymentCallback = (Error?) -> Void

    private let fareCalculator: FareCalculator
    private let paymentMethod: PaymentMethod

    init(
        fareCalculator: FareCalculator,
        paymentMethod: PaymentMethod
    ) {
        self.fareCalculator = fareCalculator
        self.paymentMethod = paymentMethod
    }

    func receivePayment(for ticket: Ticket, completion: ReceivePaymentCallback) {
        let fare = fareCalculator.calculateFare(for: ticket)
        paymentMethod.receivePayment(amount: fare.totalPayable, completion: completion)
    }
}
