//
//  AddTransactionPresenter.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 13/02/25.
//

import Foundation

protocol AddTransactionPresentationLogic: AnyObject {
    func didUpdateUI(type: TransactionType)
    func didUpdateCategories(with categories: [Category])
    func didAddTransaction()
    func didReceiveError()
}

final class AddTransactionPresenter {
    private weak var view: AddTransactionDisplayLogic?
    
    init(view: AddTransactionDisplayLogic) {
        self.view = view
    }
}

extension AddTransactionPresenter: AddTransactionPresentationLogic {
    func didUpdateUI(type: TransactionType) {
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, YYYY HH:mm"
        
        let dateString = formatter.string(from: dateNow)
        let viewModel = AddTransactionScreenViewModel(isIncome: type == .income, dateAndTime: dateString)
        view?.updateUI(viewModel: viewModel)
    }
    
    func didUpdateCategories(with categories: [Category]) {
        let viewModel = categories.map { category in
            CategoryViewModel(id: category.id ?? UUID(), title: category.title ?? "Sem título")
        }
        view?.didRefreshCategories(viewModel)
    }
    
    func didReceiveError() {
        notifyAlert(title: "Erro", message: "Não foi possível adicionar esta transação. Tente novamente em instantes.")
    }
    
    func didAddTransaction() {
        notifyAlert(title: "Sucesso", message: "Sua transação foi adicionada!")
    }
}

private extension AddTransactionPresenter {
    func notifyAlert(title: String, message: String) {
        let alertViewModel = AlertViewModel(title: title, message: message)
        view?.showAlertView(alertViewModel)
    }
}
