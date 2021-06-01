//
//  SendMoneySuccessViewController.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/1/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

protocol SendMoneyDelegate {
    func dismissP2PView()
    func showRequestMoney()
    func showSendMoney()
}

class SendMoneySuccessViewController: UIViewController {
    
    @IBOutlet weak var successMessageLbl: UILabel!
    @IBOutlet weak var paymentSentLbl: UILabel!
    @IBOutlet weak var thankyouLbl: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    var hugoId: String?
    var successMessage: String?
    var delegate: SendMoneyDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTexts()
        configureButtons()
    }
    
    func seeTransactionDetails() {
        let vc = SendMoneyTransactionDetailViewController.instantiate(fromAppStoryboard: .SendMoney)
        vc.delegate = self.delegate
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel.transactionHugoId = hugoId
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func configureTexts() {
        self.successMessageLbl.text = successMessage ?? ""
        paymentSentLbl.text = "hp_full_send_money_success_title".localizedString
        detailBtn.setTitle("hp_full_send_money_success_details_button_title".localizedString,
                           for: .normal)
        otherBtn.setTitle("hp_full_send_money_success_new_transaction_button_title".localizedString,
                          for: .normal)
    }
    
    func configureButtons() {
        otherBtn.layer.cornerRadius = 25.0
        otherBtn.layer.borderColor = UIColor.headerPurple.cgColor
        otherBtn.layer.borderWidth = 0.5
        otherBtn.clipsToBounds = true
    }
    
    
    @IBAction func didTapSeeTransactionDetail(_ sender: Any) {
        seeTransactionDetails()
    }
    
    // MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        dismiss(animated: true)
        delegate.dismissP2PView()
    }
}
