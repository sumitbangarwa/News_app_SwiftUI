//
//  FavouriteViewModel.swift
//  NewsApp
//
//  Created by Sumit Bangarwa on 29/09/23.
//

import SwiftUI

@MainActor
class FavouriteViewModel: ObservableObject {

    @Published private(set) var favouriteNews: [Article] = []
    private let dataStore = SaveDataModel<[Article]>(filename: "bookmarks")
    
    static let shared = FavouriteViewModel()
    private init() {
        Task {
            await load()
        }
    }
    
    private func load() async {
        favouriteNews = await dataStore.load() ?? []
    }
    
    func isSaved(for article: Article) -> Bool {
        favouriteNews.first { article.id == $0.id } != nil
    }
    
    func addToFavourite(for article: Article) {
        guard !isSaved(for: article) else {
            return
        }

        favouriteNews.insert(article, at: 0)
        favouriteNewsListUpdate()
    }
    
    func removeFavourite(for article: Article) {
        guard let index = favouriteNews.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        favouriteNews.remove(at: index)
        favouriteNewsListUpdate()
    }
    
    private func favouriteNewsListUpdate() {
        let bookmarks = self.favouriteNews
        Task {
            await dataStore.save(bookmarks)
        }
    }
}
