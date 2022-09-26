//
//  ViewController.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 22/09/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var hiddenPass: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.serUIView()
    }
    
    func serUIView() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 20
        
        let image = UIImage(systemName: "circle")!
        hiddenPass.setTitle("Show Password", for: .normal)
        hiddenPass.setImage(image, for: .normal)
        hiddenPass.tintColor = .black
        hiddenPass.titleLabel?.textAlignment = .left
        hiddenPass.setTitleColor(UIColor.black, for: .normal)
        hiddenPass.contentHorizontalAlignment = .leading
        self.passField.isSecureTextEntry = true
    }
    
    func loginServer(user: String?, pass : String?, completeHandler: @escaping (Bool) -> Void ) {
        
    }

}

extension ViewController {
    @IBAction func onClickLogin() {
        print("Login")
        
        self.loginServer(user: self.userField.text, pass: self.passField.text) { success in
            if success {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UploadView")
                let navigator = UINavigationController.init(rootViewController: viewcontroller)
                self.view.window?.rootViewController = navigator
                self.view.window?.makeKeyAndVisible()
            } else {
                let alert = UIAlertController.alertActionWarning(message: "Failed to login") { action in
                    //
                }
                self.present(alert!, animated: true)
            }
        }
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
}

