//
//  NewsManager.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 24.10.2023.
//

import Foundation

class NewsManager {
    private let apiKey = "###"
    
    func getNews(category: String, completion: @escaping ([NewsResponse.Article]) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=\(apiKey)")
        else {
            print("Failure to make URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failure to get data")
                return
            }
            
            do {
                let newResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(newResponse.articles)
            } catch {
                print("Failure to convert data \(error.localizedDescription)")
            } //: do
        }.resume()
        
        /*
         Function #1: getNews:

         https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=\(apiKey)

         Function #2: getNewsFromSearch:

         https://newsapi.org/v2/everything?q=\(search)&apiKey=\(apiKey)
        */
    }
    
    func getNewsFromSearch(search: String, completion: @escaping ([NewsResponse.Article]) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(search)&apiKey=\(apiKey)")
        else {
            print("Failure to make URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failure to get data")
                return
            }
            
            do {
                let newResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(newResponse.articles)
            } catch {
                print("Failure to convert data \(error.localizedDescription)")
            } //: do
        }.resume()
        
         
    }
    
}

struct NewsResponse: Decodable {
    var status: String
    var totalResults: Int
    var articles: [Article]
    
    struct Article: Decodable, Identifiable {
        var title: String
        var description: String?
        var url: String
        var urlToImage: String?
        var content: String?
    }
}

extension NewsResponse.Article {
    var id: String {
        return url
    }
}
