//
//  ProfileViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var descriptionOfUserLabel: UILabel!
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var replacePhotoButton: UIButton!

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    //@IBOutlet weak var gcdButton: UIButton!
    //@IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var cancelNavItem: UIBarButtonItem!

    private var isChangeInfo: Bool = false

    public var imagePickerController: UIImagePickerController?

    let container: UIView = UIView()
    var profileInteractor = ProfileInteractor(profileDataManager:
                                StorageManager(coreDataStack:
                                    NestedWorkersCoreDataStack.shared))
    var isEdit: Bool = false {
        didSet {
//            operationButton.isHidden = !operationButton.isHidden
//            gcdButton.isHidden = !gcdButton.isHidden
            replacePhotoButton.isHidden = !replacePhotoButton.isHidden
            nameField.isHidden = !nameField.isHidden
            saveButton.isHidden = !saveButton.isHidden
            editButton.isHidden = !editButton.isHidden
            descriptionField.isHidden = !descriptionField.isHidden
            nameOfUserLabel.isHidden = !nameOfUserLabel.isHidden
            descriptionOfUserLabel.isHidden = !descriptionOfUserLabel.isHidden
            if isEdit {
                updateEditMode()
            } else {
                updateProfileMode()
            }

        }
    }

    @IBAction func cancelEdit(_ sender: Any) {
        isEdit = !isEdit
    }

    @IBAction func changeNameField(_ sender: Any) {
        setEnabledSaveButton()
    }

    @IBAction func changeDescriptionField(_ sender: Any) {
        setEnabledSaveButton()
    }

    func setEnabledSaveButton() {
        if !isChangeInfo {
//            gcdButton.isEnabled = true
//            operationButton.isEnabled = true
            saveButton.isEnabled = true
            isChangeInfo = true
        }
    }

    @IBAction func closeKeyboard(_ sender: Any) {
        nameField.endEditing(true)
        descriptionField.endEditing(true)
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.nameOfUserLabel.text = self.profileInteractor.name
            self.descriptionOfUserLabel.text = self.profileInteractor.description
            self.imageProfile.image = self.profileInteractor.imageData
        }
    }

    private func loadProfile() {
        editButton.isHidden = false
        container.isHidden = false
        registerNotifications()
        profileInteractor.loadProfile {
            self.updateUI()
        }
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] else { return }
        if let keyboardSize = (userInfo as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 80
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    private func updateEditMode() {
        nameField.text = profileInteractor.name
        descriptionField.text = profileInteractor.description
        container.isHidden = true
//        gcdButton.isEnabled = false
//        operationButton.isEnabled = false
        saveButton.isEnabled = false
        isChangeInfo = false
        cancelNavItem.title = "Отменить"
        cancelNavItem.isEnabled = true
    }

    private func updateProfileMode() {
        updateUI()
        container.isHidden = true
        cancelNavItem.title = ""
        cancelNavItem.isEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // print(editButton.frame)
        // Проблема в том, что мы пытаемся вывести frame до полной инициализации editButton(самого объекта)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelNavItem.title = ""
        cancelNavItem.isEnabled = false
//        gcdButton.isEnabled = false
//        operationButton.isEnabled = false
        saveButton.isEnabled = false
        setCornersPhotoView()
        setEditButton()
        loadProfile()
        showActivityIndicatory(uiView: view)
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        nameField.delegate = self
        descriptionField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /* Разные значения, потому что в viewDidAppear используются размеры размера на запускаемом устройстве,
         а в viewDidLoad используется размер экрана, указанного в .stoyboard */
    }

    @IBAction func openActionSheet(_ sender: UIButton) {
        showActionSheet()
    }

    @IBAction func closeProfileWindow(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

//    @IBAction func saveWithGCD(_ sender: UIButton) {
//        nameField.endEditing(true)
//        descriptionField.endEditing(true)
//        profileInteractor.profileDataManager = GCDDataManager()
//        saveProfile()
//    }
//
//    @IBAction func saveWithOperation(_ sender: Any) {
//        nameField.endEditing(true)
//        descriptionField.endEditing(true)
//        profileInteractor.profileDataManager = OperationDataManager()
//        saveProfile()
//    }

    @IBAction func saveWithCoreData(_ sender: UIButton) {
        nameField.endEditing(true)
        descriptionField.endEditing(true)
        saveProfile()
    }

    @IBAction func editProfile(_ sender: UIButton) {
        isEdit = !isEdit
    }

    private func saveProfile() {
        guard let name = nameField.text, let description = descriptionField.text,
            let image = imageProfile.image else { return }
        container.isHidden = false
//        gcdButton.isEnabled = false
//        operationButton.isEnabled = false
        saveButton.isEnabled = false
        replacePhotoButton.isEnabled = false
        profileInteractor.saveProfile(name: name,
                                      description: description,
                                      image: image) { (error) in

            if error == nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
                        UserDefaults.standard.set(name, forKey: "name")
                        if self.isEdit {
                            self.isEdit = false
                        } else {
                            self.updateUI()
                        }
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Ошибка",
                                              message: "Не удалось сохранить данные", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
                    self.container.isHidden = true
                }
                let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                    self.saveProfile()
                }
                alert.addAction(okAction)
                alert.addAction(repeatAction)
                self.present(alert, animated: true, completion: nil)
            }

//            self.gcdButton.isEnabled = true
//            self.operationButton.isEnabled = true
            self.saveButton.isEnabled = true
            self.replacePhotoButton.isEnabled = true
        }
    }
}

// MARK: - Image Picker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imageProfile.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        setEnabledSaveButton()
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - Action Sheet Photo
private extension ProfileViewController {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard let controller = self.imagePickerController else { return }
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
                                            handler: { (_: UIAlertAction) -> Void in
            self.openPhotoLibrary()
        }))

        actionSheet.addAction(UIAlertAction(title: "Сделать фото",
                                            style: UIAlertAction.Style.default,
                                            handler: { (_: UIAlertAction) -> Void in
            self.openCamera()
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)

    }
}

// MARK: - UI Improvements
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

    func showActivityIndicatory(uiView: UIView) {
        container.isHidden = true
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }

    func UIColorFromHex(rgbValue: UInt32, alpha: Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
