//
//  UploadImageVC.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 26/09/2022.
//

import Foundation
import UIKit

class UploadViewController : UIViewController {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var uploadBut: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigator()
        setView()
    }
    
    func setupNavigator() {
        self.title = "Upload Image"
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.backgroundColor = .systemGray5
        self.navigationController?.navigationBar.standardAppearance = apperance
        self.navigationController?.navigationBar.scrollEdgeAppearance = apperance
        
        let button = UIBarButtonItem(image: UIImage.init(systemName: "plus.circle.fill")!, style: .plain, target: self, action: #selector(onUploadPicture))
        button.tintColor = .black
        self.navigationItem.rightBarButtonItem = button
    }
    
    func setView() {
        self.addImageButton.setTitle("+", for: .normal)
        var config = UIButton.Configuration.plain()
           config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
           var outgoing = incoming
           outgoing.font = .systemFont(ofSize: 50)
           return outgoing
        }
        self.addImageButton.configuration = config
        self.addImageButton.tintColor = .black
        self.addImageButton.layer.borderWidth = 0.5
        
        self.uploadBut.setTitle("Upload", for: .normal)
        self.uploadBut.setTitleColor(UIColor.black, for: .normal)
        self.uploadBut.backgroundColor = .systemFill
        self.uploadBut.layer.borderWidth = 0.5
        self.uploadBut.layer.cornerRadius = 20
    }
}

extension UploadViewController {
    @objc func onUploadPicture() {
        
    }
    
    @IBAction func onClickAddImage() {
        
    }
    
    @IBAction func onClickUploadImage() {
        
    }
}
