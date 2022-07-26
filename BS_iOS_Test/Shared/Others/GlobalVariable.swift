//
//  GlobalVariable.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import Foundation

class GlobalVariable {
    
    static var shared = GlobalVariable()
    
    var token: String?
      
}

extension GlobalVariable{
    
    func getJwt() -> String? {
        
        if let token = self.token{
            return "Bearer" + " " + "\(token)"

        }else{
            return nil
        }
    }
    
    class func clearGlobalVariable() {
        shared = GlobalVariable()
    }
}
