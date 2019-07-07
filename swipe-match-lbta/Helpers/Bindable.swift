//
//  Bindable.swift
//  swipe-match-lbta
//
//  Created by Karlis Berzins on 07/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }

    var observer: ((T?) -> ())?

    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
