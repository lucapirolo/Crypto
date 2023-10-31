//
//  Persistence.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.

import CoreData

/// A controller responsible for managing persistent storage of cryptocurrency data.
struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    /// Initializes a new `PersistenceController`.
    /// - Parameter inMemory: A Boolean value indicating whether the store should be in memory. Useful for unit testing.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Crypto")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Public Methods
    
    /// Fetches all cached cryptocurrencies sorted by market cap rank.
    /// - Returns: An array of `CryptoCurrencyEntity`.
    func fetchCachedCryptos() -> [CryptoCurrencyEntity] {
        let fetchRequest = NSFetchRequest<CryptoCurrencyEntity>(entityName: "CryptoCurrencyEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CryptoCurrencyEntity.marketCapRank, ascending: true)]
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch cached cryptocurrencies: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Updates the holdings amount for a specific cryptocurrency.
    /// - Parameters:
    ///   - cryptoId: The ID of the cryptocurrency for which to update the holdings.
    ///   - holdings: The new holdings amount.
    func setHoldings(for cryptoId: String, holdings: Double) {
        let backgroundContext = container.viewContext
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        backgroundContext.perform {
            let fetchRequest = NSFetchRequest<CryptoCurrencyEntity>(entityName: "CryptoCurrencyEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", cryptoId)
            
            do {
                let fetchedResults = try backgroundContext.fetch(fetchRequest)
                if let cryptoEntity = fetchedResults.first {
                    cryptoEntity.holdings = holdings
                    self.commitChanges(in: backgroundContext)
                }
            } catch {
                print("Failed to fetch or update cryptocurrency: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetches a cryptocurrency with a specific ID from the persistent store.
    /// - Parameter cryptoId: The ID of the cryptocurrency to fetch.
    /// - Returns: An optional `CryptoCurrencyEntity`. Returns `nil` if not found.
    func fetchCrypto(byId cryptoId: String) -> CryptoCurrencyEntity? {
        let fetchRequest = NSFetchRequest<CryptoCurrencyEntity>(entityName: "CryptoCurrencyEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", cryptoId)
        fetchRequest.fetchLimit = 1
        
        do {
            return try container.viewContext.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch cryptocurrency with ID \(cryptoId): \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Internal Persistence Methods
    
    /// Saves or updates an array of `Cryptocurrency` objects in the persistent store.
    /// - Parameter cryptos: An array of `Cryptocurrency` objects to be saved or updated.
    func saveCryptocurrencies(_ cryptos: Cryptos) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        backgroundContext.perform {
            for crypto in cryptos {
                self.saveOrUpdateCryptocurrency(crypto, in: backgroundContext)
            }
            self.commitChanges(in: backgroundContext)
        }
    }

    // MARK: - Private Helper Methods
    
    /// Saves or updates a single cryptocurrency entity in the given context.
    /// - Parameters:
    ///   - crypto: The `Cryptocurrency` object to be saved or updated.
    ///   - context: The `NSManagedObjectContext` in which the operation should occur.
    private func saveOrUpdateCryptocurrency(_ crypto: Cryptocurrency, in context: NSManagedObjectContext) {
        let existingEntity = fetchExistingEntity(for: crypto.id, in: context)
        if let existingEntity = existingEntity {
            existingEntity.update(with: crypto)
        } else {
            _ = crypto.toEntity(in: context)
        }
    }

    /// Fetches an existing cryptocurrency entity with a specific ID from the context.
    /// - Parameters:
    ///   - id: The ID of the cryptocurrency to fetch.
    ///   - context: The `NSManagedObjectContext` to perform the fetch in.
    /// - Returns: An optional `CryptoCurrencyEntity`. Returns `nil` if not found.
    private func fetchExistingEntity(for id: String, in context: NSManagedObjectContext) -> CryptoCurrencyEntity? {
        let fetchRequest: NSFetchRequest<CryptoCurrencyEntity> = CryptoCurrencyEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching cryptocurrency: \(error.localizedDescription)")
            return nil
        }
    }

    /// Commits any changes in the given context to the persistent store.
    /// - Parameter context: The `NSManagedObjectContext` in which to commit changes.
    private func commitChanges(in context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save changes: \(error.localizedDescription)")
            }
        }
    }
}
