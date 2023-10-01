//
//  ApiResponseModel.swift
//  NewsApp
//
//  Created by Sumit Bangarwa on 29/09/23.
//

import Foundation

struct ApiResponseModel: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
    
}
