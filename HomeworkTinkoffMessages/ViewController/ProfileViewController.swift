//
//  ProfileViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//
import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var replacePhotoButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // print(editButton.frame)
        // Проблема в том, что мы пытаемся вывести frame до полной инициализации editButton(самого объекта)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(editButton.frame)
        setCornersPhotoView()
        setEditButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(editButton.frame)
        /* Разные значения, потому что в viewDidAppear используются размеры размера на запускаемом устройстве,
         а в viewDidLoad используется размер экрана, указанного в .stoyboard */
    }
 
    
    @IBAction func openActionSheet(_ sender: UIButton) {
        print("Выбери изображение профиля")
        showActionSheet()
    }
    
}


// MARK: -Image Picker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageProfile.image = info[UIImagePickerController.InfoKey.originalImage]! as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: -Action Sheet Photo
private extension ProfileViewController {
    func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.camera

        self.present(myPickerController, animated: true, completion: nil)

    }

    func photoLibrary() {

        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary

        self.present(myPickerController, animated: true, completion: nil)

    }

    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Установить из галлереи", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Сделать фото", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))


        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)

    }
}


// MARK: -UI Improvements
private extension ProfileViewController {
    func setCornersPhotoView() {
        let corners = replacePhotoButton.frame.height/2
        replacePhotoButton.layer.cornerRadius = corners
        imageProfile.layer.cornerRadius = corners
    }
       
    func setEditButton() {
        editButton.layer.cornerRadius = 10
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 2
        editButton.clipsToBounds = true
    }
}
