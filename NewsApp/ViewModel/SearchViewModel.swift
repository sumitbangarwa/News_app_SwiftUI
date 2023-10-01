//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Sumit Bangarwa on 29/09/23.
//

import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {

    @Published var phase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery = ""
    @Published var history = [String]()
    private let searchHistoryData = SaveDataModel<[String]>(filename: "searchHistory")
    private let historyMaxLimit = 10
    
    private let newsAPI = ApiManager.shared
    private var trimmedSearchQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static let shared = SearchViewModel()
    
    private init() {
        load()
    }
    
    func addHistory(_ text: String) {
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == historyMaxLimit {
            history.remove(at: history.count - 1)
        }
        
        history.insert(text, at: 0)
        updateSearchHistory()
    }
    
    func removeHistory(_ text: String) {
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) else {
            return
        }
        history.remove(at: index)
        updateSearchHistory()
    }
    
    func removeAllHistory() {
        history.removeAll()
        updateSearchHistory()
    }
    
    func searchArticle() async {
        if Task.isCancelled { return }
        
        let searchQuery = trimmedSearchQuery
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .failure(error)
        }
    }
    
    private func load() {
        Task {
            self.history = await searchHistoryData.load() ?? []
        }
    }
    
    private func updateSearchHistory() {
        let history = self.history
        Task {
            await searchHistoryData.save(history)
        }
    }
}

