//
//  RequestMoneySuccessViewController.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/15/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class RequestMoneySuccessViewController: UIViewController {

    @IBOutlet weak var successMessageLbl: UILabel!
    @IBOutlet weak var paymentSentLbl: UILabel!
    @IBOutlet weak var thankyouLbl: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    var hugoId: Int?
    var successMessage: String?
    var delegate: SendMoneyDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTexts()
        configureButtons()
    }
    
    func seeTransactionDetails() {
        let vc = RequestMoneyTransactionDetailViewController.instantiate(fromAppStoryboard: .RequestMoney)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self.delegate
        vc.viewModel.transactionHugoId = String(hugoId ?? 0)
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func configureTexts() {
        let font = UIFont(name: "GothamHTF-Light", size: 13.0)
        self.successMessageLbl.attributedText = successMessage?.withBoldText(text: "hugo", font: font, fontColorBold: .lightGray1)
        paymentSentLbl.text = "hp_full_request_money_success_title".localizedString
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
