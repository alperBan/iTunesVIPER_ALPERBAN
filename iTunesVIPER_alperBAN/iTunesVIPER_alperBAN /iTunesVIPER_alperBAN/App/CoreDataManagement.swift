//
//  CoreDataManagement.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 16.06.2023.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iTunesVIPER_alperBAN")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchSongs() -> [SongModel]? {
        let request: NSFetchRequest<SongModel> = SongModel.fetchRequest()
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch let error {
            print("Failed to fetch songs: \(error)")
            return nil
        }
    }
}
