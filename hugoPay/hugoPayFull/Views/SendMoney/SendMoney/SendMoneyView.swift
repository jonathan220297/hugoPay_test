//
//  SendMoneyView.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/26/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift

class SendMoneyView: UIView {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sendPaymentLbl: UILabel!
    @IBOutlet weak var recipientLbl: UIView!
    @IBOutlet weak var selectedContactView: SelectedContactView!
    @IBOutlet weak var phoneView: HugoPayPhoneView!
    @IBOutlet weak var paymentAmountLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    @IBOutlet weak var emailTextfield: UITextField! {
        didSet {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray2 ]
            let placeholder = NSAttributedString(string: "hp_full_send_money_enter_email_placeholder".localizedString,
                                                        attributes: attributes)
            
            emailTextfield.attributedPlaceholder = placeholder
            emailTextfield.keyboardType = .emailAddress
            emailTextfield.borderStyle = .none
            emailTextfield.addLine(position: .bottom, color: .lightGray2, width: 0.5)
        }
    }
    
    
    // MARK: - Properties
    
    var view: UIView!
    var pullUpView: PullUpView!
    var amountTextfield: UITextField?
    private let disposeBag = DisposeBag()
    private let generator = UINotificationFeedbackGenerator()
    
    var sendMoneyConfirmation: ((_ recipientType: RecipientType,
                                 _ areacode: String,
                                 _ recipient: String,
                                 _ sendAmount: Double,
                                 _ contact: HugoPayContact?) -> ())?
    
    lazy var viewModel: SendMoneyViewModel = {
        return SendMoneyViewModel()
    }()
    
    func removeViews() {
        guard let view = self.view else { return }
        view.endEditing(true)
        view.removeFromSuperview()
    }
    
    func prepareViews(_ vc_view: PullUpView)  {
        let nib = Bundle.main.loadNibNamed("SendMoneyView", owner: self, options: nil)
        
        if let view = nib?.first as? UIView {
            pullUpView = vc_view
            vc_view.addSubview(view)
            let newHeight = vc_view.frame.height
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            configurePhoneView()
            configureViewModel()
            configureAmountLabel()
            configureRx()
            
            //Notifications
            addObservers()
            
            view.frame = CGRect(x: 0, y: 0, width: vc_view.frame.width, height: newHeight)
            view.backgroundColor = .clear
            
            self.view = view
        }
    }
    
    func configurePhoneView() {
        phoneView.removeObservers = { [weak self] in
            guard let self = self else { return }
            self.removeObservers()
        }
        phoneView.addObservers = { [weak self] in
            guard let self = self else { return }
            self.addObservers()
        }
    }
    
    func configureViewModel() {
        viewModel.countryData = phoneView.selectedCountry
    }
    
    func configureAmountLabel() {
        let amountLblTap = UITapGestureRecognizer(target: self, action: #selector(didTapAmountLbl))
        amountLblTap.numberOfTapsRequired = 1
        amountLbl?.addGestureRecognizer(amountLblTap)
        amountLbl?.isUserInteractionEnabled = true
        amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
    }
    
    func configureRx() {
        phoneView
            .phoneTxt
            .rx
            .value
            .asObservable()
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] phone in
                guard let self = self else { return }
                self.viewModel.phoneNumber = phone
            })
            .disposed(by: disposeBag)
        
        emailTextfield
            .rx
            .value
            .asObservable()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                self.viewModel.email = email
            })
            .disposed(by: disposeBag)
        
        phoneView
            .hasSelectContact
            .asObservable()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                self.emailTextfield.isHidden = status
                self.viewModel.isUSingContact = status
            })
            .disposed(by: disposeBag)
    }
    
    func removeObservers() {
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        view.endEditing(true)
        guard let sendAmount = amountLbl.text,
        let areaCode = phoneView.countryCodeLbl.text else { return }
        let recipientType: RecipientType = viewModel.phoneNumber.isEmpty ? .email : .phone
        let recipient = viewModel.phoneNumber.isEmpty ? viewModel.email : phoneView.getPhoneNumber()
        
        
        if viewModel.fieldsNeedInput {
            viewModel.showMessagePrompt("hp_full_invalid_fields".localizedString)
            generator.notificationOccurred(.error)
            
            return
        }

        
        if !viewModel.isUSingContact && !phoneView.isValidPhone() && viewModel.email.isEmpty {
            viewModel.showMessagePrompt("hp_full_invalid_phone".localizedString)
            generator.notificationOccurred(.error)
            
            return
        }
        
        if viewModel.textfieldShouldShake && viewModel.phoneNumber.isEmpty {
            viewModel.showMessagePrompt("hp_full_invalid_email".localizedString)
            generator.notificationOccurred(.error)
            
            return
        }
        
        if !viewModel.phoneNumber.isEmpty && !viewModel.email.isEmpty {
            viewModel.showMessagePrompt("hp_full_invalid_fields".localizedString)
            generator.notificationOccurred(.error)
            
            return
        }
                
        if viewModel.verifySendMoneyInfo(with: sendAmount) {
            removeObservers()
            let sendAmountAsDouble = Double(sendAmount.removeFormatAmount())
            generator.notificationOccurred(.success)
            sendMoneyConfirmation?(recipientType, areaCode, recipient, sendAmountAsDouble, phoneView.selectedContact ?? nil)
        } else {
            generator.notificationOccurred(.error)
            viewModel.showMessagePrompt("hp_full_invalid_amount".localizedString)
        }
    }
    
    
    // MARK: - Observers
    @objc func dismissKeyboard() {
        view.endEditing(true)
        amountTextfield?.resignFirstResponder()
        emailTextfield?.resignFirstResponder()
        if let viewWithTag = self.view.viewWithTag(99999) {
            viewWithTag.endEditing(true)
            viewWithTag.removeFromSuperview()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification
                                .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.pullUpView.updateHeight(with: 411 + keyboardSize.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.pullUpView.updateHeight(with: 411)
    }
    
    @objc func didTapAmountLbl() {
        generator.notificationOccurred(.warning)
        amountTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        amountTextfield?.viewWithTag(9999999)
        guard let textfield = amountTextfield else { return }
        self.view.addSubview(textfield)
        textfield.addTarget(self, action: #selector(textFieldMoneyDidChange), for: .editingChanged)
        textfield.keyboardType = .numberPad
        textfield.becomeFirstResponder()
        textfield.text = amountLbl.text?.replacingOccurrences(of: viewModel.userManager.symbol ?? "$", with: "")
    }
    
    @objc func textFieldMoneyDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = amountLbl.text?.replacingOccurrences(of: viewModel.userManager.symbol ?? "$",
                                                                         with: "")
        } else if textField.text! == "0.000" || textField.text! == "0.0000" {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = "0.00"
        } else if textField.text! == "0.0" || textField.text! == "0." {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = "0.00"
        } else if textField.text == "0.00" {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = "0.00"
        } else if let amountString = textField
                    .text?
                    .currencyInputFormatting(with: viewModel.userManager.symbol ?? "$") {
            amountLbl.textColor = .headerPurple
            amountLbl.text = amountString
        }
    }
}
