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
    
    func requestWithCode(phone: String, code: String, comletion: @escaping(Bool) -> Void) {
        var url = URLRequest(url: URL(string: serverURL + "verify-code")!)
        url.httpMethod = "POST"
        url.httpBody = try! JSONEncoder().encode(CodeRequestVerify(phone: phone, verification_code: code))
        url .setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            
            guard let responseData = data else {
                print("No response data")
                return
            }
            do {
                
                let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: responseData)
                
                
                if serverResponse.status == "error" {
                    comletion(false)
                   
                } else {
                    comletion(true)
                }
            } catch {
              
            }
        }
        
        
        task.resume()
    }
}







