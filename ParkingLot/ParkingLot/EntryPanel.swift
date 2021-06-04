//
//  EntryPanel.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

enum VehicleType {
    case handicapped
    case motorcycle
    case car
    case bus
    case truck
    case electric
}

class EntryPanel {
    let id: String = UUID().uuidString
    private var printingService: PrintingService
    private var parkingService: ParkingService

    init(
        printingService: PrintingService,
        parkingService: ParkingService
    ) {
        self.printingService = printingService
        self.parkingService = parkingService
    }

    func requestTicket(vehicleId: String, vehicleType: VehicleType) {
        let spotTypes = getAllowedSpotTypesForVehicleType(vehicleType)
        requestTicket(vehicleId: vehicleId, allowedSpotTypes: spotTypes)
    }

    func requestTicket(vehicleId: String, allowedSpotTypes: [SpotType]) {

        let request = ParkingRequest(
            vehicleId: vehicleId,
            entranceId: id,
            allowedSpotTypes: allowedSpotTypes
        )

        parkingService.entry(request) { result in
            switch result {
                case .success(let ticket):
                    self.printingService.printTicket(ticket)
                case .failure(let error):
                    self.printingService.printError(error)
            }
        }
    }

    // MARK: - Helpers

    private func getAllowedSpotTypesForVehicleType(_ vehicleType: VehicleType) -> [SpotType] {
        switch vehicleType {
            case .handicapped:
                return [.handicapped]
            case .motorcycle:
                return [.small]
            case .car:
                return [.medium]
            case .bus, .truck:
                return [.large]
            case .electric:
                return [.electric]
        }
    }
}

