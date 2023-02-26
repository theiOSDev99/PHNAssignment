//
//  PHNHomePresenter.swift
//  PHNAssignment
//
//  Created by Admin on 25/02/23.
//

import Foundation

protocol PHNResponseHomePresenterProtocol {
    func success(homeModel: [PHNModel])
    func failure(error: PHNUILayerError)
}

enum PHNUILayerError: Error {
    case apiFailure
    case networkError
    case dataError
    case unknown
}

struct PHNHomePresenterResponse {
    var result: Result<[PHNModel], PHNUILayerError>
}

class PHNHomePresenter {
    var delegate: PHNResponseHomePresenterProtocol?
    private let service = PHNHomeService()
    func fetchData() {
        service.delegate = self
        service.fetchData()
    }
}

extension PHNHomePresenter : PHNHomeResponceServiceProtocol {
    func receivedData(response: PHNHomeServiceResponse) {
        switch response.result {
        case .success(let data) :
            var arrHomePageList: [PHNModel] = []
            for item in data {
                let model = PHNModel(title: item.title, price: item.price, name: item.category.name, image: item.category.image, images: item.images, desc: item.desc)
                arrHomePageList.append(model)
            }
            if let del = delegate {
                del.success(homeModel: arrHomePageList)
            }
            
            case .failure(let errorFailure):
                if let del = delegate {
                    var uiLayerError: PHNUILayerError =  .unknown
                    switch errorFailure {
                        case .apiFailure,.apiInvalid:
                        uiLayerError = .apiFailure
                        case .dataError, .parseFail:
                        uiLayerError = .dataError
                        case .networkError:
                        uiLayerError = .networkError
                        default:
                        uiLayerError = .unknown
                    }
                del.failure(error: uiLayerError)
            }
        }
    }
}
