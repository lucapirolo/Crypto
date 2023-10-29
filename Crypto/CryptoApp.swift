//
//  CryptoApp.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

@main
struct CryptoApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        ValueTransformer.setValueTransformer(SparklineTransformer(), forName: NSValueTransformerName("SparklineTransformer"))

    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
