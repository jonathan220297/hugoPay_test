//
//  NotificationsHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 30/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class NotificationsHPFullViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backToMain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
