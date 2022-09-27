//
//  UploadImageVC.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 26/09/2022.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class UploadViewController : UIViewController {
    
    var addImageButton = UIButton(type: .roundedRect)
    var uploadBut = UIButton()
        
    var imagePost: UIImage? {
        didSet {
            self.addImageButton.setBackgroundImage(self.imagePost, for: .normal)
        }
    }
    
    var collectionName = ""
    
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
        self.view.addSubview(self.addImageButton)
        self.addImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.addImageButton.setTitle("+", for: .normal)
        self.addImageButton.titleLabel?.font = .systemFont(ofSize: 50)
//        if #available(iOS 15.0, *) {
//            var config = UIButton.Configuration.plain()
//            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//                var outgoing = incoming
//                outgoing.font = .systemFont(ofSize: 50)
//                return outgoing
//            }
//            self.addImageButton.configuration = config
//        } else {
//            // Fallback on earlier versions
//        }
        self.addImageButton.tintColor = .black
        self.addImageButton.layer.borderWidth = 0.5
        self.addImageButton.addTarget(self, action: #selector(onClickAddImage), for: .touchUpInside)
        
        let contraints = [
            self.addImageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150),
            self.addImageButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 70),
            self.addImageButton.widthAnchor.constraint(equalToConstant: 250),
            self.addImageButton.heightAnchor.constraint(equalToConstant: 250)
        ]

        NSLayoutConstraint.activate(contraints)

        
        self.view.addSubview(self.uploadBut)
        self.uploadBut.translatesAutoresizingMaskIntoConstraints = false
        self.uploadBut.setTitle("Upload", for: .normal)
        self.uploadBut.setTitleColor(UIColor.black, for: .normal)
        self.uploadBut.backgroundColor = .systemFill
        self.uploadBut.layer.borderWidth = 0.5
        self.uploadBut.layer.cornerRadius = 20
        self.uploadBut.addTarget(self, action: #selector(onUploadPicture), for: .touchUpInside)
        
        let contraints1 = [
            self.uploadBut.topAnchor.constraint(equalTo: self.addImageButton.bottomAnchor, constant: 50),
            self.uploadBut.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
            self.uploadBut.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100),
            self.uploadBut.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(contraints1)
    }
}

extension UploadViewController {
    
    @objc func onClickAddImage() {
        let action = [
            UIAlertAction(title: "Camera", style: .default, handler: { action in
                self.onClickCamera()
                self.imagePickerFromCamera()
            }),
            UIAlertAction(title: "Photos", style: .default, handler: { action in
                self.onClickPictureInLibary()
                self.imagePickerFromPhotos()
            })
        ]
        
        let alert = UIAlertController.alertSheet(action: action, completion: { action in
            //
        })
        self.present(alert, animated: true)
    }
    
    @objc func onClickUploadImage() {
        
    }
    
    @objc func onUploadPicture() {
        let alert = UIAlertController.alertTextField(title: "Collection Name", placeHolder: "name") { text, action in
            if action?.title == "OK" {
                self.createNewCollection(title: text, description: "Collection of plants", permission: false)
            }
        }
        self.present(alert, animated: true)
    }
}

extension UploadViewController {
    
    func onClickCamera() {
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success {
                print("Access success")
            }
        }
    }
    
    func onClickPictureInLibary() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch (status) {
            case .authorized :
                print("Access photo")
                break
            case .denied :
                break
            case .limited :
                break
            case .notDetermined :
                break
            case .restricted :
                break
            @unknown default:
                fatalError("No access to photo")
            }
        }
    }
    
    func imagePickerFromCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.cameraDevice = .front
        self.present(picker, animated: true)
    }
    
    func imagePickerFromPhotos() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            picker.allowsEditing = false
            self.present(picker, animated: true)
        }
    }
}

extension UploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.imagePost = image
                self.addImageButton.setTitle("", for: .normal)
//                self.addImageButton.setBackgroundImage(image, for: .normal)
            }
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let provide = results.first?.itemProvider {
            if provide.canLoadObject(ofClass: UIImage.self) {
                provide.loadObject(ofClass: UIImage.self) { reading, error in
                    if error == nil {
                        let image = reading as? UIImage
                        DispatchQueue.main.async {
                            self.imagePost = image
                            self.addImageButton.setTitle("", for: .normal)
//                            self.addImageButton.setBackgroundImage(image, for: .normal)
                        }
                    }
                }
            }
        }
    }
}

extension UploadViewController {
    
    func getCollection(id : String) {
        let query = [
            "id"       : id
        ]
        
        let host = DeviceUtilities.getHostForAction(style: .kNone)
        
        APIManager.shared.requestAPI(method: "GET", host: host, path: "/collections/:id", query: query, style: .kTypeUser) { Data, results in
            switch (results) {
            case .success(let success) :
                DispatchQueue.main.async {
                    if success {
                        let alert = UIAlertController.alertActionInfo(message: "Add collection complete")
                        self.present(alert!, animated: true)
                    } else {
                        let alert = UIAlertController.alertActionInfo(message: "Add collection failed")
                        self.present(alert!, animated: true)
                    }
                }
                break
                
            case .failure(let error) :
                DispatchQueue.main.async {
                    let alert = UIAlertController.alertActionInfo(message: "Add collection falied with error : \(error)")
                    self.present(alert!, animated: true)
                }
                break
            }
        }
    }
    
    func createNewCollection(title : String, description: String, permission: Bool ) {
        let query = [
            "title"       : title,
            "description" : description,
            "private"     : permission == true ? "true" : "false"
        ]
        
        let host = DeviceUtilities.getHostForAction(style: .kNone)
        
        APIManager.shared.requestAPI(method: "POST", host: host, path: "/collections", query: query, style: .kTypeUser) { Data, results in
            switch (results) {
            case .success(let success) :
                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.set(Data!["id"] , forKey: "id_collection")
                        let alert = UIAlertController.alertActionInfo(message: "Add collection complete")
                        self.present(alert!, animated: true)
                    } else {
                        let alert = UIAlertController.alertActionInfo(message: "Add collection failed")
                        self.present(alert!, animated: true)
                    }
                }
                break
                
            case .failure(let error) :
                DispatchQueue.main.async {
                    let alert = UIAlertController.alertActionInfo(message: "Add collection falied with error : \(error)")
                    self.present(alert!, animated: true)
                }
                break
            }
        }
    }
    
    func addNewPhotos(title: String) {
        let id = UserDefaults.standard.value(forKey: "id_collection") as! String
        
        let query = [
            "collection_id" : id,
            "photo_id"      : title
        ]
        
        let host = DeviceUtilities.getHostForAction(style: .kNone)
        
        APIManager.shared.requestAPI(method: "POST", host: host, path: "/collections/:collection_id/add", query: query, style: .kTypeUser) { Data, results in
            switch (results) {
            case .success(let success) :
                DispatchQueue.main.async {
                    if success {
                        let alert = UIAlertController.alertActionInfo(message: "Add photo complete")
                        self.present(alert!, animated: true)
                    } else {
                        let alert = UIAlertController.alertActionInfo(message: "Add photo failed")
                        self.present(alert!, animated: true)
                    }
                }
                break
                
            case .failure(let error) :
                DispatchQueue.main.async {
                    let alert = UIAlertController.alertActionInfo(message: "Add photo falied with error : \(error)")
                    self.present(alert!, animated: true)
                }
                break
            }
        }
    }
}
