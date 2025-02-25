//
//  AddTransactionBuilder.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 13/02/25.
//

import UIKit

struct AddTransactionBuilder {
    static func build(with type: TransactionType) -> AddTransactionViewController {
        let view = AddTransactionViewController()
        let presenter = AddTransactionPresenter(view: view)
        
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let cdTransaction = CDManager<Transaction>(context: coreDataContext)
        let cdCategory = CDManager<Category>(context: coreDataContext)
        
        let transactionDataManager = CDTransactionManager(coreDataManager: cdTransaction)
        let categoryDataManager = CDCategoryManager(coreDataManager: cdCategory)
        
        let interactor = AddTransactionInteractor(
            presenter: presenter,
            transactionDataManager: transactionDataManager,
            categoryDataManager: categoryDataManager,
            transactionType: type,
            dataContext: coreDataContext
        )
        
        view.interactor = interactor
        return view
    }
}
