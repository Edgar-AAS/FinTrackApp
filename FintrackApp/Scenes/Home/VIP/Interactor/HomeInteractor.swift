//
//  HomeInteractor.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 17/02/25.
//

import Foundation

protocol HomeBusinessLogic {
    func fetchTransactionsWith(offset: Int, limit: Int)
}

final class HomeInteractor: HomeBusinessLogic {
    private let coreDataHomeManager: CDHomeManagerProtocol
    private let presenter: HomePresentationLogic
    
    init(coreDataHomeManager: CDHomeManagerProtocol, presenter: HomePresentationLogic) {
        self.coreDataHomeManager = coreDataHomeManager
        self.presenter = presenter
    }
    
    func fetchTransactionsWith(offset: Int, limit: Int) {
        coreDataHomeManager.fetchPaginatedTransactions(offset: offset, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    self?.presenter.didLoadTransactions(response: transactions)
                case .failure:
                    return
                }
            }            
        }
    }
}
