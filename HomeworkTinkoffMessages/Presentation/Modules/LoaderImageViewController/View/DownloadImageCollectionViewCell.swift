//
//  DownloadImageCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import UIKit

class DownloadImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var downloadImage: UIImageView!
    var imageUpload: Bool = false
    var url: URL!
}
