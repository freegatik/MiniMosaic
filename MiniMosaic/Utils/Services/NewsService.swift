//
//  NewsService.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 18.01.2023.
//

import Foundation
import Alamofire

final class NewsService: NewsProviding {
    private let apiKey = APIKeys.newsAPIKey
    private let baseURL = "https://newsapi.org/v2/top-headlines"

    init() {}
    
    func fetchTopHeadlines(completion: @escaping (Result<NewsResponse, Error>) -> Void) {
        let url = "\(baseURL)?country=us&apiKey=\(apiKey)"
        
        AF.request(url).responseDecodable(of: NewsResponse.self) { response in
            switch response.result {
            case .success(let newsResponse):
                completion(.success(newsResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
