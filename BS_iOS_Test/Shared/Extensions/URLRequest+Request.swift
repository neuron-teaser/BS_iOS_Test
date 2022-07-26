//
//  URLRequest+Request.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import Foundation
import UIKit


extension URLRequest{
    
    static func requestWith(resource:Resource)-> URLRequest{
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        print("url: \(resource.url)")
        request.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        if let authorizationToken = resource.authorization {
            print("auth : \(authorizationToken)")
            request.setValue(authorizationToken, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        return request
    }
}

extension NSMutableURLRequest {
    
    static func requestWithAsset(url: URL, parameter: [String: Any]?, httpMethod: String, imageToUpload: UIImage?) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url:url as URL);
        request.httpMethod = httpMethod
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let authorizationToken = GlobalVariable.shared.getJwt() {
            request.setValue(authorizationToken, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        var imageData = NSData()
        if let image = imageToUpload {
            imageData = image.jpegData(compressionQuality: 0.25)! as NSData
        }
        
        request.httpBody = createBodyWithParameters(parameters: parameter, filePathKey: "profile_pic", imageDataKey: imageData as NSData, boundary: boundary, imgKey: "profile_image") as Data
        
        return request
    }
    
    static func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imgKey: String) -> NSData {
            let body = NSMutableData();
    
            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }
    
            let filename = "\(imgKey).jpg"
            let mimetype = "image/jpg"
    
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")
    
            return body
        }
    
        static func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }

    
    
    static func createRequestWithMultipleImage(url: URL, parameter: [String: Any]?, httpMethod: String) -> NSMutableURLRequest {

        let request = NSMutableURLRequest(url:url as URL);
        request.httpMethod = httpMethod
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let authorizationToken = GlobalVariable.shared.getJwt() {
            request.setValue(authorizationToken, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        if let parameter = parameter {
            request.httpBody = try? createBody(with: parameter, boundary: boundary)

        }
        
        if let json = try? JSONSerialization.jsonObject(with: request.httpBody!, options: .allowFragments) as? [String: Any] {
            print("json data: \(json)")
        }

        return request
    }

    static func createBody(with parameters: [String: Any], boundary: String) throws -> Data {

        let body = NSMutableData()

        for (key, value) in parameters {

            if(value is String || value is NSString) {
                body.appendString(string: "--\(boundary)\r\n")

                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }else if let image = value as? UIImage {
                let r = arc4random()
                let filename = "image\(r).jpg"
                let data = image.jpegData(compressionQuality: 0.25);
                let mimetype = "image/jpg"

                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                body.append(data!)
                body.appendString(string: "\r\n")
            }

        }

        body.appendString(string: "--\(boundary)--\r\n")

        return body as Data

    }
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

enum HTTPHeaderField: String {
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case acceptLangauge  = "Accept-Language"
}
enum ContentType: String {
    case json            = "application/json"
    case multipart       = "multipart/form-data"
    case ENUS            = "en-us"
}
