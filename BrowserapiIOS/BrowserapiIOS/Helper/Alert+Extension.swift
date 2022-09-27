//
//  Alert+Extension.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 26/09/2022.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func alertActionInfo(message: String?, completion: ((UIAlertAction?) -> Void)? = nil ) -> UIAlertController? {
        if let mess = message {
            let alert = UIAlertController.init(title: "Notification", message: mess, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default) { action in
                if (completion != nil) {
                    completion!(action)
                }
            }
            alert.addAction(action)
            return alert
        }
        if (completion != nil) {
            completion!(nil)
        }
        return nil
    }

    
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
    
    static func alertActionWaiting(message: String?, completion:@escaping (UIAlertAction?) -> Void) -> UIAlertController {
        
        let alert = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
        
        if message != nil {
            let indicator = UIActivityIndicatorView(frame: CGRectMake(5, 5, 50, 50))
            indicator.hidesWhenStopped = true
            indicator.style = .medium
            indicator.startAnimating();
            alert.view.addSubview(indicator)
        } else {
            let indicator = UIActivityIndicatorView(frame: CGRectMake(50, 10, 50, 50))
            indicator.hidesWhenStopped = true
            indicator.style = .medium
            indicator.startAnimating();
            alert.view.addSubview(indicator)
        }
        completion(nil)
        return alert
    }
    
    static func alertSheet(action: [UIAlertAction], completion:@escaping (UIAlertAction?) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for act in action {
            alert.addAction(act)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        completion(nil)
        return alert
    }
    
    static func alertTextField(title:String?, placeHolder:String, completion:@escaping (String,UIAlertAction?) -> Void) -> UIAlertController {
        let text = ""
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            completion("",action)
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            completion(alert.textFields![0].text!,action)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.addTextField { field in
            //
        }
        
        return alert
    }
}
