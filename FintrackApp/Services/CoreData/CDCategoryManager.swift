import Foundation
import CoreData

protocol CDCategoryManagerProtocol {
    func fetchById(_ id: UUID, completion: @escaping (Result<Category, CoreDataError>) -> Void)
    func addCategory(_ category: Category, completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func fetchAllCategories(completion: @escaping (Result<[Category], CoreDataError>) -> Void)
    func deleteCategory(_ category: Category, completion: @escaping (Result<Void, CoreDataError>) -> Void)
}

final class CDCategoryManager: CDCategoryManagerProtocol {
    private let coreDataManager: CDManager<Category>
    
    init(coreDataManager: CDManager<Category>) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchById(_ id: UUID, completion: @escaping (Result<Category, CoreDataError>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        coreDataManager.find(by: predicate, completion: completion)
    }
    
    func addCategory(_ category: Category, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        coreDataManager.add(category, completion: completion)
    }
    
    func fetchAllCategories(completion: @escaping (Result<[Category], CoreDataError>) -> Void) {
        coreDataManager.fetchAll(completion: completion)
    }
    
    func deleteCategory(_ category: Category, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        coreDataManager.delete(category, completion: completion)
    }
}
