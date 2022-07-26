//
//  MovieListDataModel.swift
//  BS-iOS-Test
//
//  Created by Jamil Bin Hossain on 25/7/22.
//

import Foundation

struct MovieListDataModel: Codable {
    var page: Int?
    var total_pages: Int?
    var total_results: Int?
    var results: [MovieListData]?
}

struct MovieListData: Codable {
    
    var adult: Bool?
    var id: Int?
    var original_title: String?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
}
