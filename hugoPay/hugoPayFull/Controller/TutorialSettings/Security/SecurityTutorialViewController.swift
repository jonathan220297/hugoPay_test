//
//  SecurityTutorialViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class SecurityTutorialViewController: UIViewController {

    @IBOutlet weak var containerBox: UIView!
    @IBOutlet weak var buttonBox: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBoxes()
    }

    func configureBoxes() {
        // Continue Box
        buttonBox.layer.roundCorners(radius: buttonBox.frame.height/2)
        buttonBox.backgroundColor = UIColor.white
        //        let tapContinue = UITapGestureRecognizer(target: self, action: #selector(continueTutorial))
        //        continueBox.isUserInteractionEnabled = true
        //        continueBox.addGestureRecognizer(tapContinue)
        // Dismiss Box
        containerBox.layer.roundCorners(radius: containerBox.frame.height/2)
        containerBox.layer.borderWidth = 1.0
        containerBox.layer.borderColor = UIColor(hex: "e2dded").cgColor
        //        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissTutorial))
        //        dismissBox.isUserInteractionEnabled = true
        //        dismissBox.addGestureRecognizer(tapDismiss)
    }

    @IBAction func continueTutorial(_ sender: Any) {
        if let vc = R.storyboard.tutorialSettingsHPFull.helpTutorialViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
