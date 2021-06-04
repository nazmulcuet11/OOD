//
//  TicketManager.swift
//  ParkingLot
//
//  Created by Nazmul Islam on 4/6/21.
//

import Foundation

protocol TicketRepositoryObserver {
    func ticketAdded(_ repository: TicketRepository, ticket: Ticket)
    func ticketRemoved(_ repository: TicketRepository, ticket: Ticket)
}

protocol TicketStore {
    @discardableResult func add(_ ticket: Ticket) -> Bool
    @discardableResult func remove(_ ticket: Ticket) -> Bool
    func getTicket(ticketId: String) -> Ticket?
}

class TicketRepository: SubscribableService {
    var weakSubscribers: [String : Weak<TicketRepositoryObserver>] = [:]

    private let store: TicketStore

    init(store: TicketStore) {
        self.store = store
    }

    @discardableResult
    func save(_ ticket: Ticket) -> Bool {
        guard getTicket(ticketId: ticket.id) == nil else {
            // can not add multiple ticket with same id
            return false
        }

        let success = store.add(ticket)
        if success {
            notifySubscribers { $0.ticketAdded(self, ticket: ticket) }
        }
        return success
    }

    @discardableResult
    func remove(_ ticket: Ticket) -> Bool {
        guard getTicket(ticketId: ticket.id) != nil else {
            return false
        }

        let success = store.remove(ticket)
        if success {
            notifySubscribers { $0.ticketRemoved(self, ticket: ticket) }
        }
        return success
    }

    func getTicket(ticketId: String) -> Ticket? {
        return store.getTicket(ticketId: ticketId)
    }
}
