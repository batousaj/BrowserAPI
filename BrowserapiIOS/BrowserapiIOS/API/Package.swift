//
//  Package.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 22/09/2022.
//

import Foundation

class Package {
    
    static func componentAPI(host: String, path: String?, query : [String:String]?) -> URLComponents {
        var component = URLComponents()
        component.host = host
        component.scheme = "https"
        
        if let path_ = path {
            component.path = path_
        }
        
        if let query = query {
            var items = [URLQueryItem]()
            for (key,value) in query {
                items.append(
                    URLQueryItem(name: key, value: value)
                )
            }
            component.queryItems = items
        }
        
        return component
    }
    
}
