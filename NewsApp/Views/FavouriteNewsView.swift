//
//  FavouriteNewsView.swift
//  NewsApp
//
//  Created by Sumit Bangarwa on 28/09/23.
//

import SwiftUI

struct FavouriteNewsView: View {
    
    @EnvironmentObject var favouriteViewModel: FavouriteViewModel
    @State var searchText: String = ""
    
    var body: some View {
        let articles = self.articles
        
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Saved Articles")
        }
        .searchable(text: $searchText)
    }
    
    private var articles: [Article] {
        if searchText.isEmpty {
            return favouriteViewModel.favouriteNews
        }
        return favouriteViewModel.favouriteNews
            .filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
    }
    
    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyStateView(text: "You dont have any favourite news saved yet", image: Image(systemName: "star.fill"))
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = FavouriteViewModel.shared

    static var previews: some View {
        FavouriteNewsView()
            .environmentObject(articleBookmarkVM)
    }
}
