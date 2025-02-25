//
//  Builder.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 17/02/25.
//
import UIKit

final class HomeBuilder {
    static func build() -> HomeViewController {
        let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreData = CDManager<Transaction>(context: dataContext)
        let coreDataHomeManager = CDHomeManager(coreDataManager: coreData)
        
        let router = HomeRouter()
        let viewController = HomeViewController()
        let presenter = HomePresenter(viewController: viewController)
        let interactor = HomeInteractor(coreDataHomeManager: coreDataHomeManager, presenter: presenter)
        
        viewController.router = router
        viewController.interactor = interactor
        router.viewController = viewController
        return viewController
    }
}
