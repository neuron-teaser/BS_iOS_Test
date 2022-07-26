//
//  SessionManager.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import Foundation

// MARK: - Manager

class SessionManager {

    // MARK: Singleton
    
    private static let instance = SessionManager()
    
    class func sharedInstance () -> SessionManager {
        return instance
    }
    
    // MARK:- Manager
    
    func save (object: Bool, key: String) {
        standard().set(object, forKey: key)
        sync()
    }
    
    func get (key: String) -> Bool {
        return standard().bool(forKey: key)
    }
    
    func delete (key: String) {
        standard().removeObject(forKey: key)
        sync()
    }
        
    // MARK:- Helpers
    
    func standard () -> UserDefaults {
        return UserDefaults.standard
    }
    
    func sync () {
        standard().synchronize()
    }
}

