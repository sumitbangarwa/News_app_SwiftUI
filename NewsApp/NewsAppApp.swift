//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Sumit Bangarwa on 28/09/23.
//

import SwiftUI

@main
struct NewsAppApp: App {
    
    @StateObject var favouriteVM = FavouriteViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favouriteVM)
        }
    }
}
