//
//  LoaderImageViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import UIKit

class LoaderImageViewController: UIViewController, ImageLoaderDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var profileController: ProfileViewController! = nil
    let assembly: IPresentationAssembly = RootAssembly().presentationAssembly
    lazy var imageLoaderInteractor: IImageLoaderInteractor = assembly.getImageLoaderInteractor()
    let space: CGFloat = 15
    let itemsPerRow = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImageList()
        imageLoaderInteractor.delegate = self
    }

    func loadImageList() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        imageLoaderInteractor.loadImageURLs()
    }

    func stopSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func updateImages() {
        stopSpinner()
        collectionView.reloadData()
    }

    func handleEror() {
        stopSpinner()
        let alert = UIAlertController(title: "Не удалось загрузить изображения",
                                      message: "Проверьте интенет соединение",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func closeImageLoader(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        loadImageList()
    }

    func setImage() {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
        let cell = collectionView.cellForItem(at: indexPath) as? DownloadImageCollectionViewCell else { return }
        if let profileVC = profileController {
            if cell.imageUpload {
                profileVC.imageProfile.image = cell.downloadImage.image
            }
        }
    }
}
