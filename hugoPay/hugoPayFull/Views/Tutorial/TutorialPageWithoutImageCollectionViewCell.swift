//
//  TutorialPageWithoutImageCollectionViewCell.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 21/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class TutorialPageWithoutImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stackViewTexts: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Functions
    func setTutorialPageDate(with data: HugoPayTutorialData?) {
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
