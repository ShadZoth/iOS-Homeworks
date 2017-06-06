//
//  Icon.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 10/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

public struct Icon {
    public var name: String = ""
    public var imageName = ""
    public var description = ""
    public var price: Double = 0.0
    public var isFeatured: Bool = false
    
    public init(name: String, imageName: String, description: String, price: Double, isFeatured: Bool) {
        self.name = name
        self.imageName = imageName
        self.description = description
        self.price = price
        self.isFeatured = isFeatured
    }
}
