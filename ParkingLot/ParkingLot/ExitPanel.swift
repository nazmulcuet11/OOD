//
//  ExitPanel.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

class ExitPanel {
    private let printingService: PrintingService
    private let parkingService: ParkingService
    private let paymentStrategies: [PaymentStrategy]

    init(
        printingService: PrintingService,
        parkingService: ParkingService,
        paymentStrategies: [PaymentStrategy]
    ) {
        self.printingService = printingService
        self.parkingService = parkingService
        self.paymentStrategies = paymentStrategies
    }

    func selectPaymentStrategy() -> PaymentStrategy {
        // TODO: - Prompt user to select a payment strategy
        // default select first
        return paymentStrategies.first ?? CashPaymentStrategy()
    }

    func processTicket(ticketId: String) {
        let strategy = selectPaymentStrategy()
        parkingService.release(ticketId, paymentStrategy: strategy) {
            result in
            switch result {
                case .success(let voucher):
                    self.printingService.printVoucher(voucher)
                case .failure(let error):
                    self.printingService.printError(error)
            }
        }
    }
}
