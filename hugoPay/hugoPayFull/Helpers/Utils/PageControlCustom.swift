//
//  PageControlCustom.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/14/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
import UIKit

public class PageControl: UIStackView {
    

    @IBInspectable var currentPageImage: UIImage = #imageLiteral(resourceName: "ic_phone")
    @IBInspectable var pageImage: UIImage = #imageLiteral(resourceName: "ic_star_white")
    /**
     Sets how many page indicators will show
     */
    var numberOfPages = 3 {
        didSet {
            layoutIndicators()
        }
    }
    /**
     Sets which page indicator will be highlighted with the **currentPageImage**
     */
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center

        layoutIndicators()
    }

    private func layoutIndicators() {

        for i in 0..<numberOfPages {

            let imageView: UIImageView

            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! UIImageView // reuse subview if possible
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
            }

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }

        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }

    private func setCurrentPageIndicator() {

        for i in 0..<arrangedSubviews.count {

            let imageView = arrangedSubviews[i] as! UIImageView

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}
