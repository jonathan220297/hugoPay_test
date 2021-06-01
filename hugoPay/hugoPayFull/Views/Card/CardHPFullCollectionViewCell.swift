//
//  CardHPFullCollectionViewCell.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 28/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class CardHPFullCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var typeLogo: UIImageView!
    @IBOutlet weak var ccNumberLbl: UILabel!
    @IBOutlet weak var ccImage: UIImageView!
    @IBOutlet weak var ccView: UIView!

    func config(_ data: CCHugoPayFull) {
        ccNumberLbl.text = "**** \(data.cardNumber?.suffix(4) ?? "")"
    }
}
