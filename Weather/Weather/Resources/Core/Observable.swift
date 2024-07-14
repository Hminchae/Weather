//
//  Observable.swift
//  Weather
//
//  Created by 황민채 on 7/14/24.
//

import Foundation

final class Observable<T> {
    
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("didSet")
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}
