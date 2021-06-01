//
//  UnlockTutorialViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class UnlockTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueTutorial(_ sender: Any) {
        if let vc = R.storyboard.tutorialHPFull.configurationTutorialViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
