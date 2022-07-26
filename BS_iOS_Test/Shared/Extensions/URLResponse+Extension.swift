//
//  URLResponse+Extension.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import Foundation

extension URLResponse {

    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
