//
//  MovieItem.swift
//  BS-iOS-Test
//
//  Created by Jamil Bin Hossain on 26/7/22.
//

import Foundation

struct MovieItem {
   var name: String
   var detail: String
   
   public init(name: String, detail: String) {
       self.name = name
       self.detail = detail
   }
}

struct Section {
   var items: [MovieCellViewModel]
   
   public init(items: [MovieCellViewModel]) {
       self.items = items
   }
}
