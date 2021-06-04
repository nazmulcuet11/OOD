//
//  ParkingLot.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

fileprivate func makeError(_ code: Int, _ message: String) -> NSError {
    return NSError(domain: "ParkingLot", code: code, userInfo: [NSLocalizedDescriptionKey: message])
}

fileprivate let spotUnavailable = makeError(0, "Spot Unavailable")
fileprivate let ticketNotFound = makeError(0, "Ticket Not Found")

protocol SpotSelector {
    func getSpot(_ request: ParkingRequest) -> Spot?
}

class ParkingLot: ParkingService {

    private let spotSelector: SpotSelector
    private let spotRepository: SpotRepository
    private let ticketRepository: TicketRepository
    private let paymentService: PaymentService
    private let queue = DispatchQueue(label: "PARKIN_LOT_QUEUE", qos: .userInitiated)

    init(
        spotSelector: SpotSelector,
        spotRepository: SpotRepository,
        ticketRepository: TicketRepository,
        paymentService: PaymentService
    ) {
        self.spotSelector = spotSelector
        self.spotRepository = spotRepository
        self.ticketRepository = ticketRepository
        self.paymentService = paymentService
    }

    func addSpot(_ spot: Spot) {
        fatalError("Not Implemented")
    }

    func addSpots(_ spots: [Spot]) {
        fatalError("Not Implemented")
    }

    func addEntryPanel(_ panel: EntryPanel) {
        fatalError("Not Implemented")
    }

    func addExitPanel(_ panel: ExitPanel) {
        fatalError("Not Implemented")
    }

    func entry(_ request: ParkingRequest, completion: @escaping EntryCompletion) {
        // synchronize
        queue.async {
            guard let spot = self.spotSelector.getSpot(request) else {
                completion(.failure(spotUnavailable))
                return
            }

            spot.assignVehicle(vehicleId: request.vehicleId)
            self.spotRepository.save(spot)

            let ticket = Ticket(
                id: UUID().uuidString,
                vehicleId: request.vehicleId,
                spotId: spot.id,
                issuedAt: Date()
            )
            self.ticketRepository.save(ticket)
            completion(.success(ticket))
        }
    }

    func release(_ ticketId: String, paymentStrategy: PaymentStrategy, completion: @escaping ReleaseCompletion) {

        guard let ticket = ticketRepository.getTicket(ticketId: ticketId) else {
            completion(.failure(ticketNotFound))
            return
        }

        paymentService.recivePayment(ticket, paymentStrategy: paymentStrategy) {
            result in
            switch result {
                case .success(let voucher):
                    guard let spot = self.spotRepository.getSpot(spotId: ticket.spotId) else {
                        fatalError("Allocated Spot Not Found for Id: \(ticket.spotId)")
                    }

                    // synchronize
                    self.queue.async {
                        spot.removeVehicle()
                        self.spotRepository.save(spot)
                        self.ticketRepository.remove(ticket)
                        completion(.success(voucher))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
