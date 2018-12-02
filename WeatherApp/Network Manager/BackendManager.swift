//
//  BackendManager.swift
//  Ordelivery
//
//  Created by MACC on 6/14/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import Alamofire

class BackendManager: NSObject {
    /// Make the network request and handles the response.
    ///
    /// - Parameters:
    ///     - urlString: The request URL string for the api.
    ///     - params: The request parameters dictionary.
    ///     - method: The request http method.
    ///     - headers: The request headers dictionary.
    ///     - encoding: The reuest parameters encoding type.
    ///     - completion: A closure to be executed once the request has finished.
    func makeApiCall(urlString: String,
                     params: [String: Any]? = nil,
                     method: HTTPMethod,
                     headers: HTTPHeaders? = nil,
                     encoding: ParameterEncoding,
                     completion: @escaping (Any?, Error?) -> ()) {
        
        let url = URL(string: urlString)!
        
        let request = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
        
        request.responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                print(JSON)
                completion(JSON, nil)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
}
