//
//  ArticleView.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 28.10.2023.
//

import SwiftUI
import Kingfisher

struct ArticleView: View {
    var article: NewsResponse.Article
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    Text(article.title)
                        .font(.title2)
                        .bold()
                    
                    KFImage(URL(string: article.urlToImage ?? ""))
                        .resizable()
                        .scaledToFill()
                    
                    Text(article.content ?? "")
                        .padding(.horizontal)
                        .font(.body)
                } //: VStack
            } //: Scroll
            .preferredColorScheme(.dark)
        } //: Nav
    }
}

#Preview {
    ArticleView(article: NewsResponse.Article(title: "", url: ""))
}
