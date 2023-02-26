//
//  PHNHomeService.swift
//  PHNAssignment
//
//  Created by Admin on 25/02/23.
//

import Foundation

protocol PHNHomeResponceServiceProtocol {
    func receivedData(response: PHNHomeServiceResponse)
}

struct PHNHomeServiceResponse {
    var result: Result<[PHNHomeServiceModel], PHNNetworkBaseError>
}

struct PHNHomeServiceModel: Decodable {
    var title: String
    var price: Int
    var category: Category
    var images: [String]
    var desc: String
    
    enum CodingKeys: String, CodingKey {
        case title, price, category, images
        case desc = "description"
    }
}

struct Category: Decodable {
    var name: String
    var image: String
}

class PHNHomeService {
    var delegate: PHNHomeResponceServiceProtocol?
    private var baseNetwork = PHNNetworkBase(baseRequest: .init(path: "products", requestType: .get, dataDict: nil))
    
    func fetchData() {

        baseNetwork.processRequest(completion: { response in
            if let del = self.delegate {
                switch response.result {
                case .success(let successData):
                    if let unwrappedData = successData as? Data {
                        del.receivedData(response: self.parseResponse(data: unwrappedData))
                    }
                case .failure(let err):
                    let response = PHNHomeServiceResponse(result: .failure(err))
                    del.receivedData(response: response)
                }
            }
        })
    }
    
    private func parseResponse(data: Data) -> PHNHomeServiceResponse {
        do {
            if let result = try? JSONDecoder().decode([PHNHomeServiceModel].self, from: data) {
                return PHNHomeServiceResponse(result: .success(result))
            }
            return PHNHomeServiceResponse(result: .failure(.dataError))
        } catch {
            return PHNHomeServiceResponse(result: .failure(.parseFail))
        }
    }
}
