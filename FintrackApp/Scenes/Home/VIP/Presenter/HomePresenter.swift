//
//  HomePresenter.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 17/02/25.
//

import Foundation

protocol HomePresentationLogic {
    func didLoadTransactions(response: [Transaction])
}

final class HomePresenter: HomePresentationLogic {
    private weak var viewController: HomeDisplayLogic?
    
    init(viewController: HomeDisplayLogic) {
        self.viewController = viewController
    }
        
    func didLoadTransactions(response: [Transaction]) {
        let viewModel = response.map { transaction in
            TransactionCell.ViewModel(
                title: transaction.title ?? "No Title",
                amount: transaction.amount.formatToCurrency(),
                date: FormatDate.format(fromFormat: "dd-MM-yyyy HH:mm", toFormat: "dd/MM/yyyy HH:mm", dateString: transaction.date ?? "") ?? "Invalid Date",
                category: transaction.category?.title ?? "No Category",
                isIncome: transaction.isIncome
            )
        }
        viewController?.didUpdateDataSource(viewModel: viewModel)
    }
}
