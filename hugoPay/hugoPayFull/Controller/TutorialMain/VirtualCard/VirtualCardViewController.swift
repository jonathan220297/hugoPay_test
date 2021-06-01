//
//  VirtualCardViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class VirtualCardViewController: UIViewController {

    @IBOutlet weak var containerBox: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBoxes()
    }

    func configureBoxes() {
        containerBox.layer.roundCorners(radius: 24.0)
        containerBox.clipsToBounds = true
    }

    @IBAction func continueTutorial(_ sender: Any) {
        if let vc = R.storyboard.tutorialHPFull.cashbackTutorialViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
