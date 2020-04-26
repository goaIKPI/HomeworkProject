//
//  LoadImageVC+CVDelegate.swift
//  TinkoffChat
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import UIKit

extension LoaderImageViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DownloadImageCollectionViewCell else { return }
        if cell.imageUpload {
            self.setImage()
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
