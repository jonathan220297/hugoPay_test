//
//  CreateAccountBasicInfoViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 18/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class CreateAccountBasicInfoViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    @IBOutlet weak var hugoPayBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }

    func configItems() {
        hugoPayBtn.makeHugoPayFullButton(title: "SIGUIENTE")
    }

    @IBAction func nextStepCreateAccount(_ sender: Any) {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.createAccount.complementInfoHPFullViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
