//
//  SendMoneyFailureViewController.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/1/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class SendMoneyFailureViewController: UIViewController {
    
    @IBOutlet weak var errorMessageLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var errorMessage: String?
    var errorCode: Int?
    var delegate: SendMoneyDelegate!
    var isRequestMoney = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTexts()
    }
    
    func configureView() {
        guard let errorCode = errorCode else { return }
        
        switch errorCode {
        case 1019:
            closeBtn.isHidden = false
            retryButton.isHidden = true
            cancelButton.isHidden = true
        default:
            closeBtn.isHidden = true
            retryButton.isHidden = false
            cancelButton.isHidden = false
            errorMessageLbl.text = "Parece que ha ocurrido un error, intenta nuevamente"
        }
    }
    
    func configureTexts() {
        closeBtn.setTitle("hp_full_send_money_failure_close_button_title".localizedString,
                          for: .normal)
    }
    
    func configureButtons() {
        
    }
    
    // MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        dismiss(animated: true)
        delegate.dismissP2PView()
    }
    
    
    @IBAction func didTapRetryBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if isRequestMoney {
            delegate.showRequestMoney()
        } else {
            delegate.showSendMoney()
        }
    }
}
