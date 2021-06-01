//
//  TutorialPageCollectionViewCell.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 20/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import Nuke

class TutorialPageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewEllipse: UIImageView!
    @IBOutlet weak var imageViewTutorial: UIImageView!
    @IBOutlet weak var stackViewTexts: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTutorialPageDate(with data: HugoPayTutorialData?) {
        if let urlString = data?.image, urlString != "", let url = URL(string: urlString) {
            Nuke.loadImage(with: url, into: imageViewTutorial)
        }
        
        guard let content = data?.content else {
            return
        }
        
        stackViewTexts.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let labelTitle = UILabel()
        labelTitle.font = R.font.gothamHTFBold(size: 17)
        labelTitle.text = data?.title?.text ?? ""
        labelTitle.numberOfLines = 0
        labelTitle.textColor = .white
        labelTitle.textAlignment = .center
        NSLayoutConstraint.activate([labelTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 21)])
        stackViewTexts.addArrangedSubview(labelTitle)
        var contents = content
        contents.removeLast()
        for text in contents {
            let label = UILabel()
            label.font = R.font.gothamHTFBook(size: 13)
            label.text = text.text ?? ""
            label.numberOfLines = 0
            label.textColor = .white
            label.textAlignment = .center
            stackViewTexts.addArrangedSubview(label)
        }
    }
}
