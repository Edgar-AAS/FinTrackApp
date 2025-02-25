//
//  HomeRouter.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 18/02/25.
//

import UIKit

enum TransactionType {
    case income
    case expanses
}

protocol HomeRountingLogic {
    func routeToAddTransaction(with transactionType: TransactionType)
}

final class HomeRouter: HomeRountingLogic {
    weak var viewController: HomeViewController?
    
    func routeToAddTransaction(with transactionType: TransactionType) {
        let addTransactionViewController = AddTransactionBuilder.build(with: transactionType)
        viewController?.navigationController?.pushViewController(addTransactionViewController, animated: true)
    }
}
