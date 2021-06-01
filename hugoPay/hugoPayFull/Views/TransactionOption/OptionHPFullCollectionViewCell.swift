//
//  OptionHPFullCollectionViewCell.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 30/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import Nuke

class OptionHPFullCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var optionView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(_ data: HomeHPFullOptions){
        if let url = URL(string: data.image ?? ""){
            Nuke.loadImage(with: url, into: image)
        }
        title.text = data.text ?? ""
    }

    func makeRound(){
        optionView.layer.roundCorners(radius: optionView.frame.size.height/2)
        optionView.layer.applySketchShadow(color: UIColor.init(hex: "474a52"), alpha: 0.1, x: 4.0, y: 3.0, blur: 10.0, spread: 0.0)
    }

    override func layoutSubviews() {
        optionView.layoutIfNeeded()
        super.layoutSubviews()
        makeRound()
    }

}
