//  NetworkHelper.swift
//  MobileCodingChallenge
//  Created by Deeksha Verma on 16/08/22.

import Foundation
let network = NetworkHelper.getInstance()

/// Network Helper Class
class NetworkHelper {
    
    /// Create Instance for Network Helper
    static var instance: NetworkHelper? = nil
    /// URL Session
    var session = URLSession.shared
    
    /// Get Instance for Network Helper
    /// - Returns: instance
    public static func getInstance() -> NetworkHelper {
        if instance == nil {
            instance = NetworkHelper()
        }
        return instance!
    }
    
    /// Post Values Access
    /// - Parameters:
    ///   - url: String
    ///   - postdata: String
    ///   - callBack: Data, Error
    func postData(_ url:String, _ postdata:String, callBack:@escaping (_ data:Data?,_ error:Error?)->(Void)) {
        var request = URLRequest(url: URL(string: url)!)
        session.configuration.timeoutIntervalForRequest = 25
        session = URLSession(configuration: URLSessionConfiguration.default)
        request.httpBody = postdata.data(using: .utf8)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            callBack(data, error)
        }
        dataTask.resume()
    }
    
    /// This method is used for GET request.
    /// - Parameters:
    ///   - url: URL to be used
    ///   - callBack: callback after GET
    func getData(_ url:String, callBack:@escaping (_ data:Data?,_ error:Error?)->(Void)) {
        var request = URLRequest(url: URL(string: url)!)
        var session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 20
        session = URLSession(configuration: URLSessionConfiguration.default)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            callBack(data,error)
        }
        dataTask.resume()
    }
}
