//
//  EditProfileViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 14.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    weak var parentController: ProfileViewController?

    //var profileDataManager: ProfileDataManager

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var replacePhotoButton: UIButton!
    @IBOutlet weak var saveGCDButton: UIButton!
    @IBOutlet weak var saveOperationButton: UIButton!

    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var descriptionField: UITextField!
    public var imagePickerController: UIImagePickerController?

//    init(profileDataManager: ProfileDataManager) {
//        super.init()
//        print("init")
//        //self.profileDataManager = profileDataManager
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setCornersPhotoView()
        setEditButton(saveGCDButton)
        setEditButton(saveOperationButton)
        // Do any additional setup after loading the view.
    }

    @IBAction func openActionSheet(_ sender: UIButton) {
        print("Выбери изображение профиля")
        showActionSheet()
    }

    @IBAction func saveDataWithGCD(_ sender: UIButton) {
        DispatchQueue.global().async {

//            if self.saveName() && self.saveDescription() && self.saveImage() {
//                DispatchQueue.main.async {
//                    self.showAlert(title: "Успешно сохранено", message: "")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.showAlertWithReload {
//                        self.saveDataWithGCD(UIButton())
//                    }
//                }
//            }
        }
    }

    @IBAction func saveDataWithOperation(_ sender: UIButton) {

    }

}

// MARK: - Image Picker
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imageProfile.image = info[UIImagePickerController.InfoKey.originalImage]! as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - Action Sheet Photo
private extension EditProfileViewController {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard let controller = self.imagePickerController else {return}
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.camera

            self.present(controller, animated: true, completion: nil)
        } else {
            showCameraIsNotAvailableAlert()
        }

    }

    func showCameraIsNotAvailableAlert() {
        let noCameraAlertController = UIAlertController(title: "No camera",
                                                        message: "The camera is not available on this device",
                                                        preferredStyle: .alert)
        let okCameraButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        noCameraAlertController.addAction(okCameraButton)
        present(noCameraAlertController, animated: true)
    }

    func openPhotoLibrary() {

        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary

        self.present(myPickerController, animated: true, completion: nil)

    }

    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: UIAlertController.Style.actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Установить из галлереи",
                                            style: UIAlertAction.Style.default,
                                            handler: { (_: UIAlertAction!) -> Void in
            self.openPhotoLibrary()
        }))

        actionSheet.addAction(UIAlertAction(title: "Сделать фото",
                                            style: UIAlertAction.Style.default,
                                            handler: { (_: UIAlertAction!) -> Void in
            self.openCamera()
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)

    }
}

// MARK: - UI Improvements
private extension EditProfileViewController {
    func setCornersPhotoView() {
        let corners = replacePhotoButton.frame.height/2
        replacePhotoButton.layer.cornerRadius = corners
        imageProfile.layer.cornerRadius = corners
    }

    func setEditButton(_ sender: UIButton) {
        sender.layer.cornerRadius = 10
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 2
        sender.clipsToBounds = true
    }
}

private extension EditProfileViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)

        alert.addAction(okAction)
        present(alert, animated: true)
    }
    func showAlertWithReload(reloadFunc: @escaping () -> Void) {
        let alert = UIAlertController(title: "Ошибка при сохранении", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let reloadAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            reloadFunc()
        }

        alert.addAction(reloadAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
