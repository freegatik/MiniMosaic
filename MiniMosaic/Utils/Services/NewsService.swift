//
//  NewsService.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 07.09.2024.
//

import Foundation
import Alamofire

class NewsService {
    
    static let shared = NewsService()
    private let apiKey = APIKeys.newsAPIKey
    private let baseURL = "https://newsapi.org/v2/top-headlines"
    
    private init() {}
    
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
