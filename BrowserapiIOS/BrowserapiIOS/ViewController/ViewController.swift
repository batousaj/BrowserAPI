//
//  ViewController.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 22/09/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var hiddenPass: UIButton!
    
    @IBOutlet weak var loginByOther: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerNotification()
        self.serUIView()
    }
    
    func serUIView() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 20
        
        loginByOther.translatesAutoresizingMaskIntoConstraints = false
        loginByOther.setTitle("Login By Upsflash", for: .normal)
        loginByOther.titleLabel?.textAlignment = .left
        loginByOther.setTitleColor(UIColor.black, for: .normal)
        loginByOther.backgroundColor = .systemGray2
        loginByOther.layer.borderWidth = 0.5
        loginByOther.layer.cornerRadius = 20
        
        let image = UIImage(systemName: "circle")!
        hiddenPass.setTitle("Show Password", for: .normal)
        hiddenPass.setImage(image, for: .normal)
        hiddenPass.tintColor = .black
        hiddenPass.titleLabel?.textAlignment = .left
        hiddenPass.setTitleColor(UIColor.black, for: .normal)
        hiddenPass.contentHorizontalAlignment = .leading
        self.passField.isSecureTextEntry = true
    }

    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(OnWebViewCreateFailed), name: NSNotification.Name("kNotifyWebViewFailed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnWebViewLoginSuccess), name: NSNotification.Name("kNotifyLoginSuccessed"), object: nil)
    }
    
}

extension ViewController {
    
    @IBAction func onClickLogin() {
        print("Login Successed")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UploadView")
        let navigator = UINavigationController.init(rootViewController: viewcontroller)
        self.view.window?.rootViewController = navigator
        self.view.window?.makeKeyAndVisible()

    }
    
    @IBAction func onClickHiddenButton() {
        if hiddenPass.titleLabel?.text == "Show Password" {
            let image = UIImage(systemName: "circle.inset.filled")!
            hiddenPass.setImage(image, for: .normal)
            hiddenPass.setTitle("Hidden Password", for: .normal)
            self.passField.isSecureTextEntry = false
        } else {
            let image = UIImage(systemName: "circle")!
            hiddenPass.setImage(image, for: .normal)
            hiddenPass.setTitle("Show Password", for: .normal)
            self.passField.isSecureTextEntry = true
        }
    }
    
    @IBAction func onLoginByUpFlash() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewLogin")
        let navigator = UINavigationController.init(rootViewController: viewcontroller)
        self.present(navigator, animated: true)
    }
}

extension ViewController {
    
    @objc func OnWebViewCreateFailed() {
        if let alert = UIAlertController.alertActionWarning(message: "Login Failed", completion: { action in
            //
        }) {
            self.present(alert, animated: true)
        }
    }
    
    @objc func OnWebViewLoginSuccess() {
        let alert = UIAlertController.alertActionWaiting(message:"Please wait" , completion: { action in
            //
        })
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.requestGetNewToken { success in
                if success {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true)
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UploadView")
                        let navigator = UINavigationController.init(rootViewController: viewcontroller)
                        self.view.window?.rootViewController = navigator
                        self.view.window?.makeKeyAndVisible()
                    }
                } else {
                    alert.dismiss(animated: true)
                    if let alert = UIAlertController.alertActionWarning(message:"Login failed" , completion: { action in
                        //
                    }) {
                        DispatchQueue.main.async {
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
}

extension ViewController {
    func requestGetNewToken(handler : @escaping (Bool) -> Void) {
        let client_id = DeviceUtilities.getAccessToken()
        let client_secret = DeviceUtilities.getSerectKey()
        let redict = DeviceUtilities.getRedictURI()
        let authorization_code = "authorization_code"
        let code = UserDefaults.standard.value(forKey: "authorization_code") as! String
        
        let query = [
            "client_id"      : client_id,
            "client_secret"  : client_secret,
            "redirect_uri"   : redict,
            "code"           : code,
            "grant_type"     : authorization_code
        ]
        
        let host = DeviceUtilities.getHostForAction(style: .kTypeUser)
        
        APIManager.shared.requestAPI(method: "POST",host:host , path: "/oauth/token", query: query, style: RequestStyle.kNone) { data, results in
            switch (results) {
                case .success(let response) :
                    for (key,value) in data! {
                        if key == "access_token" {
                            UserDefaults.standard.set(value, forKey: key)
                        }
                        
                        if key == "token_type" {
                            UserDefaults.standard.set(value, forKey: key)
                        }
                    }
                    handler(response)
                    break
                case .failure(let error) :
                    handler(false)
                    print("\(error)")
                    break
            }
        }
    }
}
