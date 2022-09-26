//
//  Alert+Extension.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 26/09/2022.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func alertActionWarning(message: String?, completion:@escaping (UIAlertAction?) -> Void) -> UIAlertController? {
        if let mess = message {
            let alert = UIAlertController.init(title: "Warning", message: mess, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default) { action in
                completion(action)
            }
            alert.addAction(action)
            return alert
        }
        completion(nil)
        return nil
    }
    
}
