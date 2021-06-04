//
//  PaymentService.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

protocol FareCalculator {
    func calculateFare(_ ticket: Ticket) -> FareDetails
}

class PaymentService {
    typealias ReceivePaymentCompletion = (Result<Voucher, Error>) -> Void

    private let fareCalculator: FareCalculator

    init(fareCalculator: FareCalculator) {
        self.fareCalculator = fareCalculator
    }

    func recivePayment(_ ticket: Ticket, paymentStrategy: PaymentStrategy, completion: @escaping ReceivePaymentCompletion) {
        let fare = fareCalculator.calculateFare(ticket)
        paymentStrategy.recievePayment(fare.totalPayable) {
            result in
            switch result {
                case .success:
                    let voucher = Voucher(
                        entryTime: ticket.issuedAt,
                        exitTime: Date(),
                        spotId: ticket.spotId,
                        vehicleId: ticket.vehicleId,
                        ticketId: ticket.id,
                        fareDetails: fare
                    )
                    completion(.success(voucher))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
