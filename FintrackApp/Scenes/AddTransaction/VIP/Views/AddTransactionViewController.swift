//
//  AddTransactionViewController.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 10/02/25.
//

import UIKit

protocol AddTransactionDisplayLogic: AnyObject {
    func updateUI(viewModel: AddTransactionScreenViewModel)
    func showAlertView(_ viewModel: AlertViewModel)
    func didRefreshCategories(_ viewModel: [CategoryViewModel])
}

final class AddTransactionViewController: UIViewController {
    var interactor: AddTransactionBusinessLogic?
    
    private lazy var customView: AddTransactionScreen = {
        guard let view = view as? AddTransactionScreen else {
            fatalError("View is not of type AddTransactionScreen")
        }
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view = AddTransactionScreen(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadInitialData()
        showNavigationBar()
    }
}

extension  AddTransactionViewController: AddTransactionScreenDelegate {
    func didAddTransactionTap(_ view: AddTransactionScreen) {
        if let addTransactionRequest = customView.getAddTransactionRequest() {
            interactor?.addTransaction(request: addTransactionRequest)
        }
    }
    
    func didAddCategoryTap(_ view: AddTransactionScreen) {
        let alertView: UIAlertController = .init(title: "Criar Categoria", message: "Adicione um titulo a categoria", preferredStyle: .alert)
        
        alertView.addTextField { field in
            field.placeholder = "Title"
        }
        
        let createAction: UIAlertAction = .init(title: "Create", style: .default) { [weak self] action in
            guard let strongSelf = self else { return }
            
            if let field = alertView.textFields?.first,
               let categoryTitle = field.text, !categoryTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                strongSelf.interactor?.addCategory(with: categoryTitle)
            }
        }
        
        let cancelAction: UIAlertAction = .init(title: "Cancel", style: .cancel)
        
        alertView.addAction(cancelAction)
        alertView.addAction(createAction)
        present(alertView, animated: true)
    }
}

extension AddTransactionViewController: AddTransactionDisplayLogic {
    func didRefreshCategories(_ categories: [CategoryViewModel]) {
        customView.updateCategoriesData(categories: categories)
    }
    
    func updateUI(viewModel: AddTransactionScreenViewModel) {
        customView.setupUI(with: viewModel)
    }
    
    func showAlertView(_ viewModel: AlertViewModel) {
        let alertView: UIAlertController = .init(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        let tapAction: UIAlertAction = .init(title: "Ok", style: .default)
        alertView.addAction(tapAction)
        present(alertView, animated: true)
    }
}
