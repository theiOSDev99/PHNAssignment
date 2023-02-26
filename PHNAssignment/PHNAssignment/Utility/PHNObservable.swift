//
//  PHNObservable.swift
//  PHNAssignment
//
//  Created by Admin on 25/02/23.
//

import Foundation

class PHNObservable <T> {
    var value: T? {
        didSet {
            self.observe?(value)
        }
    }
    
    init (value: T) {
        self.value = value
    }
    
    private var observe: ((T?) -> ())?
    
    func addObservale(completionHandler: @escaping (T?) -> ()) {
        observe = completionHandler
    }
}
