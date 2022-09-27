//
//  NewLoginView.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 27/09/2022.
//

import Foundation
import UIKit
import WebKit

class NewLoginView : UIViewController {
    
    var webView : WKWebView!
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func setupWebView() {
        self.title = "Up Flash"
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onBackLoginView))
        button.tintColor = .black
        self.navigationItem.leftBarButtonItem = button
        self.view.addSubview(self.webView)
        self.loadWebView()
    }
    
    func loadWebView() {
        let client_id = DeviceUtilities.getAccessToken()
        let redict = DeviceUtilities.getRedictURI()
        let user_access = DeviceUtilities.getUserAccess()
        let response_type = "code"
        
        let query = [
            "client_id"      : client_id,
            "redirect_uri"   : redict,
            "response_type"  : response_type,
            "scope"          : user_access
        ]
        
        let host = DeviceUtilities.getHostForAction(style: .kTypeUser)
        
        if let url = Package.componentAPI(host: host, path: "/oauth/authorize", query: query).url {
            let request = URLRequest(url: url)
            self.webView.load(request)
            
        } else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("kNotifyWebViewFailed"), object: nil)
            }
            self.dismiss(animated: true)
            
        }
    }
    
    func handleLoginWithAuthen(value:String?) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: "authorization_code")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("kNotifyLoginSuccessed"), object: nil)
            }
            self.dismiss(animated: true)
        } else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("kNotifyWebViewFailed"), object: nil)
            }
            self.dismiss(animated: true)
        }
    }
    
}

extension NewLoginView : WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let url = webView.url {
            let component = URLComponents(string: url.absoluteString)
            if let query = component?.queryItems {
                for que in query {
                    if que.name == "code" {
                        self.handleLoginWithAuthen(value: que.value)
                        return
                    }
                }
            }
        }
    }
}

extension NewLoginView {
    @objc func onBackLoginView() {
        self.dismiss(animated: true)
    }
}
