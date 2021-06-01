//
//  CashinSucessViewController.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

protocol CashinDelegate {
    func dismissCashinProcess()
}

class CashinSucessViewController: UIViewController {
    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var labelHugoThanks: UILabel!
    
    var hugoId = ""
    var balance = ""
    
    var delegate: CashinDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Actions
    @IBAction func buttonDetailTapped(_ sender: Any) {
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {
            if let vc = R.storyboard.hugoPayFullCashIn.cashinTransactionDetailViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                pvc?.present(vc, animated: true) {
                    vc.assingTransactionID(with: self.hugoId)
                }
            }
        }
    }
    
    @IBAction func buttonDismissTapped(_ sender: Any) {
//        delegate.dismissCashinProcess()
        dismiss(animated: true)
    }
    
    // MARK: - Functions
    fileprivate func configureViews() {
        labelHugoThanks.attributedText = NSMutableAttributedString().normal("hp_CashinSucessViewController_ThanksForUse".localized).bold("hugo").normal("Pay!")
        buttonDismiss.layer.borderWidth = 1.0
        buttonDismiss.layer.borderColor = UIColor(named: "DeepPurple")!.cgColor
    }
}

extension CashinSucessViewController: CashinTransactionDetail {
    func dismissSuccesController() {
        self.dismiss(animated: true) {
            self.delegate.dismissCashinProcess()
        }
    }
}
