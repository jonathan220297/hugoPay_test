//
//  SendTutorialViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class SendTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueTutorial(_ sender: Any) {
        if let vc = R.storyboard.tutorialHPFull.transferTutorialViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
