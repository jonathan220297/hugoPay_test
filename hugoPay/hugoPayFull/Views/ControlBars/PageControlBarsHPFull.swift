//
//  PageControlBarsHPFull.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class PageControlBarsHPFull: UIView {
    
    // Number of pages
    var numberOfPages: Int = 0
    
    // Current Page
    var currentPage: Int = 0
    
    // Current Bar Color
    var currentBarColor: UIColor = .darkGray
    
    // Bar Color
    var barColor: UIColor = .lightGray
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    func renderPageControlBars() {
        subviews.forEach { $0.removeFromSuperview() }
        
        let marginMiddleX: CGFloat = (bounds.width / 2) - ((29 * CGFloat(numberOfPages) + 5 * CGFloat(numberOfPages - 1)) / 2)
        var retainMarginX: CGFloat = marginMiddleX
        
        if numberOfPages > 0 {
            for index in 0...numberOfPages - 1 {
                let barView = UIView(frame: CGRect(x: retainMarginX,
                                                   y: (bounds.height / 2) - (2 / 2),
                                                   width: 29,
                                                   height: 2))
                barView.layer.cornerRadius = 2.5
                barView.layer.masksToBounds = true
                barView.tag = index
                
                if currentPage == index {
                    barView.backgroundColor = currentBarColor
                }
                else {
                    barView.backgroundColor = barColor
                }
                
                retainMarginX = barView.frame.origin.x + barView.bounds.width + 5
                self.addSubview(barView)
            }
        }
    }
    
    func assignCurrentPage(index: Int) {
        currentPage = index
        
        renderPageControlBars()
    }
    
}
