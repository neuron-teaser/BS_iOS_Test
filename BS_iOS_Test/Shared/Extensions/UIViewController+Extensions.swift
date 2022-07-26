//
//  UIViewController+Extensions.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import UIKit

extension UIViewController {
    
    static func instantiate<T>(storyBoard: String) -> T {
        let storyboard = UIStoryboard(name: storyBoard, bundle: .main)
        let controller = storyboard.instantiateViewController(identifier: "\(T.self)") as! T
        return controller
    }
}

enum StoryBoard: String {
    
    case movie = "Movie"
    
    var name:String {
        return self.rawValue
    }
}
