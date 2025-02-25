//
//  CDHomeManager.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 21/02/25.
//

import Foundation

protocol CDHomeManagerProtocol {
    func fetchPaginatedTransactions(offset: Int, limit: Int, completion: @escaping (Result<[Transaction], CoreDataError>) -> Void)
}

final class CDHomeManager: CDHomeManagerProtocol {
    private let coreDataManager: CDManager<Transaction>
    
    init(coreDataManager: CDManager<Transaction>) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchPaginatedTransactions(offset: Int, limit: Int, completion: @escaping (Result<[Transaction], CoreDataError>) -> Void) {
        coreDataManager.filter(filterModel: .init(descriptors: [NSSortDescriptor(key: "date", ascending: false)], limit: limit, offset: offset), completion: completion)
    }
}
