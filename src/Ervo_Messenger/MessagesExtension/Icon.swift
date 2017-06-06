//
//  Icon.swift
//  CollectionViewDemo
//
//  Created by Студент on 26/04/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import IconDataKit
import Messages

public extension Icon {
    
    enum QueryItemKey: String {
        case name = "name"
        case imageName = "imageName"
        case description = "description"
        case price = "price"
    }
    
    public var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: QueryItemKey.name.rawValue, value: name))
        items.append(URLQueryItem(name: QueryItemKey.imageName.rawValue, value: imageName))
        items.append(URLQueryItem(name: QueryItemKey.description.rawValue, value: description))
        items.append(URLQueryItem(name: QueryItemKey.price.rawValue, value: String(price)))
        return items
    }
    
    public init(queryItems: [URLQueryItem]) {
        self.name = ""
        self.description = ""
        self.imageName = ""
        self.price = 0.0
        self.isFeatured = false
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            if queryItem.name == QueryItemKey.name.rawValue {
                self.name = value
            }
            if (queryItem.name == QueryItemKey.imageName.rawValue) {
                self.imageName = value
            }
            if (queryItem.name == QueryItemKey.description.rawValue) {
                self.description = value
            }
            if (queryItem.name == QueryItemKey.price.rawValue) {
                self.price = Double(value) ?? 0.0
            }
        }
    }
    
    public init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = URLComponents(url: messageURL, resolvingAgainstBaseURL:false), let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
}
