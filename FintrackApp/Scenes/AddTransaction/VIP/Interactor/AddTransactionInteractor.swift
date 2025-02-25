//
//  AddTransactionInteractor.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 13/02/25.
//

import Foundation
import CoreData

protocol AddTransactionBusinessLogic {
    func loadInitialData()
    func addTransaction(request: AddTransactionRequest)
    func addCategory(with title: String)
}

final class AddTransactionInteractor {
    private let presenter: AddTransactionPresentationLogic
    private let transactionDataManager: CDTransactionManagerProtocol
    private let categoryDataManager: CDCategoryManagerProtocol
    private let transactionType: TransactionType
    private let dataContext: NSManagedObjectContext
    
    init(
        presenter: AddTransactionPresentationLogic,
        transactionDataManager: CDTransactionManagerProtocol,
        categoryDataManager: CDCategoryManagerProtocol,
        transactionType: TransactionType,
        dataContext: NSManagedObjectContext
    ) {
        self.presenter = presenter
        self.transactionDataManager = transactionDataManager
        self.categoryDataManager = categoryDataManager
        self.transactionType = transactionType
        self.dataContext = dataContext
    }
}

extension AddTransactionInteractor: AddTransactionBusinessLogic {
    func addCategory(with title: String) {
        let category = Category(context: dataContext)
        category.id = UUID()
        category.title = title
        category.note = "Some Note"
        
        categoryDataManager.addCategory(category) { [weak self] result in
            self?.handleCategoryResult(result)
        }
    }
    
    func loadInitialData() {
        categoryDataManager.fetchAllCategories { [weak self] result in
            self?.handleInitialDataResult(result)
        }
    }
    
    func addTransaction(request: AddTransactionRequest) {
        categoryDataManager.fetchById(request.categoryId) { [weak self] result in
            self?.handleFetchByIdResult(result: result, request: request)
        }
    }
}

private extension AddTransactionInteractor {
    func handleFetchByIdResult(result: Result<Category, CoreDataError>, request: AddTransactionRequest) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let parentCategory):
                self?.handleAddTransaction(to: parentCategory, with: request)
            case .failure:
                self?.presenter.didReceiveError()
            }
        }
    }
    
    func handleAddTransaction(to parentCategory: Category, with request: AddTransactionRequest) {
        let transaction = Transaction(context: dataContext)
        transaction.id = UUID()
        transaction.title = request.title
        transaction.amount = request.amount
        transaction.isIncome = request.isIncome
        transaction.note = request.description
        transaction.date = request.date
        transaction.category = parentCategory
        
        transactionDataManager.addTransaction(transaction) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.presenter.didAddTransaction()
                case .failure:
                    self?.presenter.didReceiveError()
                }
            }
        }
    }
    
    func handleCategoryResult(_ result: Result<Void, CoreDataError>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success:
                self?.updateCategories()
            case .failure:
                self?.presenter.didReceiveError()
            }
        }
    }
    
    func updateCategories() {
        categoryDataManager.fetchAllCategories { [weak self] result in
            self?.handleCategoryFetchResult(result)
        }
    }
    
    func handleInitialDataResult(_ result: Result<[Category], CoreDataError>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.presenter.didUpdateUI(type: transactionType)
                self.presenter.didUpdateCategories(with: categories)
            case .failure:
                self.presenter.didReceiveError()
            }
        }
    }
    
    func handleCategoryFetchResult(_ result: Result<[Category], CoreDataError>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let categories):
                self?.presenter.didUpdateCategories(with: categories)
            case .failure:
                self?.presenter.didReceiveError()
            }
        }
    }
}
