//
//  FailureCashinViewController.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class FailureCashinViewController: UIViewController {
    @IBOutlet weak var labelMessageFailure: UILabel!
    
    var messageFailure = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMessageFailure.text = messageFailure
    }
    
    // MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
