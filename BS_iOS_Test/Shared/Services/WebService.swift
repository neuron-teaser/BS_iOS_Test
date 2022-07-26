//
//  WebService.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
    case nullData
    case data
    case offline
    case invalidURL
    case undefined
}

enum Result<T,H> {
    case success(T,H)
    case failure(H)
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias HandlerResult = Result<Data,Error>

struct Resource {
    let url: URL
    var authorization: String?
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource{
    init(url: URL) {
        self.url = url
    }
}

class WebService {
    
    static func load(resource:Resource,completion:@escaping(HandlerResult)->Void )  {
        
        URLSession.shared.dataTask(with: URLRequest.requestWith(resource: resource)) {(data, reponse, error) in
            
            guard let data = data, error == nil else {
                //completion(.failure(NetworkError.offline))
                return
            }
            
            if let statusCode = reponse?.getStatusCode(){
                
                if let status = HTTPStatusCodes.init(rawValue: statusCode){
                    print("statusCode of \(resource.url):",statusCode)
                    //                    print("resource.authorization : \(resource.authorization)")
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                            print("json data: \(json)")
                        }
                    }
                    catch let error {
                        print("error in catch block")
                        print(error)
                    }
                    
                    completion(.success(data, status))
                }
            }
        }.resume()
    }
    
    func getData(url: URL, asset: UIImage? = nil, parameter: [String: Any]? = nil, httpMethod: String, completion:@escaping(HandlerResult)->Void) {
        
        let task = URLSession.shared.dataTask(with: (NSMutableURLRequest.requestWithAsset(url: url, parameter: parameter, httpMethod: httpMethod, imageToUpload: asset) as NSMutableURLRequest) as URLRequest) {
            (data, response, error) in
            
            guard let data = data, error == nil else {
                //completion(.failure(NetworkError.offline))
                return
            }
            
            
            if let statusCode = response?.getStatusCode(){
                
                if let status = HTTPStatusCodes.init(rawValue: statusCode){
                    print("statusCode:",statusCode)
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                            print("json data: \(json)")
                        }
                    }
                    catch let error {
                        print(error)
                    }
                    
                    completion(.success(data, status))
                }
            }
        }
        task.resume()
    }
    
    
    func postData(url: URL, parameter: [String: Any]? = nil, httpMethod: String, completion:@escaping(HandlerResult)->Void) {
        let task = URLSession.shared.dataTask(with: (NSMutableURLRequest.createRequestWithMultipleImage(url: url, parameter: parameter, httpMethod: httpMethod) as NSMutableURLRequest) as URLRequest)        {
            (data, response, error) in
            
            guard let data = data, error == nil else {
                //completion(.failure(NetworkError.offline))
                return
            }
            
            
            if let statusCode = response?.getStatusCode(){
                
                if let status = HTTPStatusCodes.init(rawValue: statusCode){
                    print("statusCode of \(url): ",statusCode)
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                            print("json data: \(json)")
                        }
                    }
                    catch let error {
                        print(error)
                    }
                    
                    completion(.success(data, status))
                }
            }
        }
        
        task.resume()
        
    }
    
    func jsonConverter(data: Data){
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(jsonResponse)
        }
        catch let error {
            print(error)
        }
        
    }
}

