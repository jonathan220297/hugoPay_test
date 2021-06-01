//
//  ViewController+Extensions.swift
//  Hugo
//
//  Created by Adonys Rauda on 3/18/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupHugoStyleNavBar(title: String = "") {
        guard let font = R.font.gothamHTFBold(size: 16),
              let color = R.color.deepPurple() else { return }
        
        self.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font,
                                                                   NSAttributedString.Key.foregroundColor: color,
                                                                   NSAttributedString.Key.kern: 1.23]
    }
}
