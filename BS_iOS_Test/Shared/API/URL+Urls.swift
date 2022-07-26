//
//  URL+Urls.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import Foundation

extension URL{
    #if QA
    static let baseUrl  = "https://api.themoviedb.org/3"
    #else
    static let baseUrl  = "https://api.themoviedb.org/3"
    #endif
}

extension URL {
    static let page = Int()
    static let movieList = "\(URL.baseUrl)/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=marvel"
}
