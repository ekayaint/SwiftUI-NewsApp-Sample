//
//  SearchView.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 22.10.2023.
//

import SwiftUI

struct SearchView: View {
    var newsManager = NewsManager()
    @State private var selectedGenre = "general"
    @State private var isLoading = true
    @State private var searchText = ""
    @State private var articles = [NewsResponse.Article]()
    
    private func updateNewsArticles () {
        newsManager.getNews(category: selectedGenre) { newsResponse in
            articles = newsResponse
            isLoading = false
        }
    }
    
    private func updateNewsArticlesFromSearch() {
        newsManager.getNewsFromSearch(search: searchText) { newsResponse in
            articles = newsResponse
            isLoading = false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    TextField("Search...", text: $searchText)
                        .padding(.leading, 20)
                    if searchText.isEmpty {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                            .padding(.leading, 8)
                    } else {
                        Button {
                            searchText = ""
                            updateNewsArticles()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                                .padding(.leading, 8)
                        }
                    } //: if
                    
                } //: HStack
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                if searchText == "" {
                    Picker("Picker", selection: $selectedGenre) {
                        Text("General").tag("general")
                        Text("Business").tag("business")
                        Text("Entertainment").tag("entertainment")
                        Text("Sports").tag("sports")
                        Text("Science").tag("science")
                    } //: Picker
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 15)
                }
                
                ScrollView {
                    if isLoading != true {
                        ForEach(articles) {article in
                            let type = predictSentiment(text: article.title)
                            NavigationLink {
                                ArticleView(article: article)
                            } label: {
                                NewsCardComponent(article: article, type: type ?? "Neutral")
                            }  
                            
                        }
                    }
                } //: ScrollView
                
            } //: VStack
            .preferredColorScheme(.dark)
            .onAppear(perform: updateNewsArticles)
            .onChange(of: selectedGenre) { _ in
                isLoading = true
                updateNewsArticles()
            }
            .onChange(of: searchText) { _ in
                isLoading = true
                updateNewsArticlesFromSearch()
            }
        } //: Nav
    }
}

#Preview {
    SearchView()
}
