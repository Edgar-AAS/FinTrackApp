import UIKit
import CoreData

protocol CDManagerProtocol {
    associatedtype Entity: NSManagedObject
    func add(_ entity: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func fetchAll(completion: @escaping (Result<[Entity], CoreDataError>) -> Void)
    func find(by predicate: NSPredicate, completion: @escaping (Result<Entity, CoreDataError>) -> Void)
    func delete(_ entity: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func filter(filterModel: FilterModel, completion: @escaping (Result<[Entity], CoreDataError>) -> Void)
}

struct FilterModel {
    let descriptors: [NSSortDescriptor]
    let limit: Int
    let offset: Int
}

enum CoreDataError: Error {
    case notFound
    case fetchFailed
    case saveFailed
}

final class CDManager<T: NSManagedObject>: CDManagerProtocol {
    typealias Entity = T
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func filter(filterModel: FilterModel, completion: @escaping (Result<[Entity], CoreDataError>) -> Void) {
        let request = Entity.fetchRequest()
        request.sortDescriptors = filterModel.descriptors
        request.fetchLimit = filterModel.limit
        request.fetchOffset = filterModel.offset
        
        do {
            if let results = try context.fetch(request) as? [Entity] {
                completion(.success(results))
            } else {
                completion(.failure(.notFound))
            }
        } catch {
            completion(.failure(.fetchFailed))
        }
    }
    
    func find(by predicate: NSPredicate, completion: @escaping (Result<Entity, CoreDataError>) -> Void) {
        let request = Entity.fetchRequest()
        request.predicate = predicate
        
        do {
            if let result = try context.fetch(request).first as? Entity {
                completion(.success(result))
            } else {
                completion(.failure(.notFound))
            }
        } catch {
            completion(.failure(.fetchFailed))
        }
    }
    
    func add(_ entity: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        context.insert(entity)
        saveContext(completion: completion)
    }
    
    func fetchAll(completion: @escaping (Result<[Entity], CoreDataError>) -> Void) {
        let request = Entity.fetchRequest()
        do {
            if let results = try context.fetch(request) as? [Entity] {
                completion(.success(results))
            } else {
                completion(.failure(.notFound))
            }
        } catch {
            completion(.failure(.fetchFailed))
        }
    }
    
    func delete(_ entity: Entity, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        context.delete(entity)
        saveContext(completion: completion)
    }
    
    private func saveContext(completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
}
