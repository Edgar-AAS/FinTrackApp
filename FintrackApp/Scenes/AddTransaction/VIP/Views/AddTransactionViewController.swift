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
        let addTransactionRequest = customView.getAddTransactionRequest()
            interactor?.addTransaction(request: addTransactionRequest)
        
    }
    
    func didAddCategoryTap(_ view: AddTransactionScreen) {
        let alertView = UIAlertController(
            title: "Criar Categoria",
            message: "Adicione um título à categoria",
            preferredStyle: .alert
        )
        
        alertView.addTextField { $0.placeholder = "Título" }
        
        let createAction = UIAlertAction(title: "Criar", style: .default) { [weak self] _ in
            guard let self = self,
                  let categoryTitle = alertView.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !categoryTitle.isEmpty else { return }
            
            self.customView.setCategoryTitle(with: categoryTitle)
            self.interactor?.addCategory(with: categoryTitle)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
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
