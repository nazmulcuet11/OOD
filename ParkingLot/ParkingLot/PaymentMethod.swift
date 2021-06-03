//
//  PaymentMethod.swift
//  ParkingLot
//
//  Created by Nazmul's Mac Mini on 3/6/21.
//

import Foundation

protocol PaymentMethod {
    typealias ReceivePaymentCallback = (Error?) -> Void

    func receivePayment(amount: Double, completion: ReceivePaymentCallback)
}
