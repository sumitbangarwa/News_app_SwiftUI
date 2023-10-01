//
//  TabBarView.swift
//  NewsApp
//
//  Created by Sumit Bangarwa on 28/09/23.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var newsVM = NewsViewModel()
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .task(id: newsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle("Top Headlines")
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        
        switch newsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyStateView(text: "No Articles", image: nil)
        case .failure(let error):
            APIFailureView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .success(articles) = newsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @Sendable
    private func loadTask() async {
        await newsVM.loadArticles()
    }
    
    
    private func refreshTask() {
        DispatchQueue.main.async {
            newsVM.fetchTaskToken = FetchTaskToken(token: Date())
        }
    }

}

struct NewsTabView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = FavouriteViewModel.shared

    
    static var previews: some View {
        NewsTabView(newsVM: NewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}

