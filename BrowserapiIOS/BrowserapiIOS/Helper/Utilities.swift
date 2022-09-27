//
//  RequestService.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 27/09/2022.
//

import Foundation

enum RequestStyle {
    case kTypeGuess
    case kTypeUser
    case kNone
}

class DeviceUtilities {
    
    static func getHostForAction(style: RequestStyle) -> String {
        if style == .kTypeUser {
            return "unsplash.com"
        } else {
            return "api.unsplash.com"
        }
    }
    
    static func getAccessToken() -> String {
        let ACCESS_TOKEN = "mkwCIbnwyRRmzHRyhS6wtD-jX1TP2aGWoz4yzYWa_Eo"
        return ACCESS_TOKEN
    }
    
    static func getRedictURI() -> String {
        let REDICT_URI = "urn:ietf:wg:oauth:2.0:oob"
        return REDICT_URI
    }
    
    static func getSerectKey() -> String {
        let SECRET_KEY = "R1couT854FQbxzFnzuUGyPbv5kRUgNRXALUG14pb4dc"
        return SECRET_KEY
    }
    
    static func getUserAccess() -> String {
        let USER_ACCESS = "public+read_user+write_collections+read_collections+write_photos+read_photos"
        return USER_ACCESS
    }
    
}
