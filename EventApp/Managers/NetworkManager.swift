//
//  NetworkManager.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 13.07.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let serverURL = "http://dev.effective-hc.com/api/"
    
    public func requestCode(phone: String, completion: @escaping(Bool) -> Void) {
        var urlRequest = URLRequest(url: URL(string: serverURL + "send-code")!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try! JSONEncoder().encode(CodeRequest(phone: phone))
        urlRequest .setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let urlSession = URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        })
        urlSession.resume()
    }
}


