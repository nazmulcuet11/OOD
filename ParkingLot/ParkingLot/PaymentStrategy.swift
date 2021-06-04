//
//  PaymentMethod.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

protocol PaymentStrategy {
    typealias RecievePaymentCompletion = (Result<Void, Error>) -> Void
    func recievePayment(_ amount: Double, completion: @escaping RecievePaymentCompletion)
}

class CashPaymentStrategy: PaymentStrategy {
    func recievePayment(_ amount: Double, completion: @escaping RecievePaymentCompletion) {
        print("Received cash payment: \(amount)")
        completion(.success(()))
    }
}

struct CreditCardInformation {
    let cardHolderName: String
    let cardNumber: String
    let ccv: String
}

protocol CardInformationProvider {
    typealias GetCardInformationCompletion = (CreditCardInformation) -> Void
    func getCardInformation(completion: @escaping GetCardInformationCompletion)
}

class CreditCardPaymentStrategy: PaymentStrategy {
    let cardInformationProvider: CardInformationProvider

    init(cardInformationProvider: CardInformationProvider) {
        self.cardInformationProvider = cardInformationProvider
    }

    func recievePayment(_ amount: Double, completion: @escaping RecievePaymentCompletion) {
        cardInformationProvider.getCardInformation {
            information in
            self.validateCardInformation(information) {
                result in
                switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }

    typealias ValidateCardInformationCompletion = (Result<Void, Error>) -> Void
    private func validateCardInformation(_ information: CreditCardInformation, completion: @escaping ValidateCardInformationCompletion) {
        completion(.success(()))
    }
}
