//
//  SuccessCreateAccountViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 19/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class SuccessCreateAccountViewController: UIViewController {

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
        hugoPayBtn.makeHugoPayFullButton(title: "CONFIGURAR MI ACCESO")
    }

    @IBAction func createAccessMethods(_ sender: Any) {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.hugoPayFull.createPinHPFullViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
