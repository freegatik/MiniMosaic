//
//  NewsModel.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 07.09.2024.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [NewsItem]
}

struct NewsItem: Decodable {
    let title: String
    let description: String?
}
