//
//  CDTransactionManager.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 12/02/25.
//

import Foundation

protocol CDTransactionManagerProtocol {
    func getAllTransactions(completion: @escaping (Result<[Transaction], CoreDataError>) -> Void)
    func deleteTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func addTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, CoreDataError>) -> Void)
}

final class CDTransactionManager: CDTransactionManagerProtocol {
    private let coreDataManager: CDManager<Transaction>
    
    init(coreDataManager: CDManager<Transaction>) {
        self.coreDataManager = coreDataManager
    }
    
    func getAllTransactions(completion: @escaping (Result<[Transaction], CoreDataError>) -> Void) {
        coreDataManager.fetchAll(completion: completion)
    }
    
    func deleteTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        coreDataManager.delete(transaction, completion: completion)
    }
    
    func addTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        coreDataManager.add(transaction, completion: completion)
    }
}

