//
//  NotifyToVC.swift
//  Raffek
//
//  Created by Asraful Alam on 29/1/21.
//

import Foundation

 protocol NotifyToVC {
     func reloadData<T>(_ data: T)
     func fetchedData<T>(_ data: T)
}

extension NotifyToVC{
    func reloadData<T>(_ data: T){}
    func fetchedData<T>(_ data: T){}
}
