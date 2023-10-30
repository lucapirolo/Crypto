//
//  Persistence.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Crypto")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    
    /// Saves an array of `Cryptocurrency` objects to the persistent store.
    /// - Parameter cryptos: An array of `Cryptocurrency` objects to be saved.
    func saveCryptocurrencies(_ cryptos: Cryptos) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        backgroundContext.perform {
            // Iterate over the array of cryptocurrencies
            for crypto in cryptos {
                // Convert the `Cryptocurrency` instance to a `CryptoCurrencyEntity`
                let _ = crypto.toEntity(in: backgroundContext)
            }
            
            // Save the context if there are changes
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                } catch {
                    print("Failed to save cryptocurrencies: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func fetchCachedCryptos() -> [CryptoCurrencyEntity] {
        let fetchRequest = NSFetchRequest<CryptoCurrencyEntity>(entityName: "CryptoCurrencyEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CryptoCurrencyEntity.marketCapRank, ascending: true)]
        do {
            let fetchedResults = try container.viewContext.fetch(fetchRequest)
            return fetchedResults
        } catch {
            return []
        }
    }

}

