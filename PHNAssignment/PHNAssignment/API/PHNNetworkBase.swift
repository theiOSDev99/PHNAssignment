//
//  PHNNetworkBase.swift
//  PHNAssignment
//
//  Created by Admin on 25/02/23.
//

import Foundation

enum PHNRequestType: Int {
    case get = 1
    case post = 2
}

struct PHNBaseRequest {
    var path: String = ""
    var requestType: PHNRequestType
    var dataDict: [String: String]?
}

enum PHNNetworkBaseError: Error {
    case apiFailure
    case apiInvalid
    case dataError
    case parseFail
    case networkError
    case unknown
}

struct PHNBaseResponse {
    var result: Result<Any?, PHNNetworkBaseError>
}

class PHNNetworkBase {
    
    private let baseUrl = "https://api.escuelajs.co/api/v1"
    private var urlStr: String
    private var request: PHNBaseRequest
    
    private init?() {
        return nil
    }
    
    init(baseRequest: PHNBaseRequest) {
        request = baseRequest
        switch request.requestType {
        case .get:
            urlStr =  baseUrl + "/" + request.path
        case .post:
            urlStr = baseUrl + "/" + request.path
        }
    }
    
    func processRequest(completion: @escaping ((_ response: PHNBaseResponse) -> Void)){
        guard let url = URL(string: urlStr) else {
            completion(PHNBaseResponse(result: .failure(.apiInvalid)))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error  in
            if error != nil {
                completion(PHNBaseResponse(result: .failure(.apiFailure)))
                return
            }
            if let theData = data {
                completion(PHNBaseResponse(result: .success(theData)))

                return
            } else {
                completion(PHNBaseResponse(result: .failure(.dataError)))
            }
        }
        dataTask.resume()
    }
}
