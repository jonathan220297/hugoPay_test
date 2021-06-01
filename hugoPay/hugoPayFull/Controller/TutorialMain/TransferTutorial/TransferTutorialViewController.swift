//
//  TransferTutorialViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class TransferTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueTutorial(_ sender: Any) {
        if let vc = R.storyboard.tutorialHPFull.notificationsTutorialViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
