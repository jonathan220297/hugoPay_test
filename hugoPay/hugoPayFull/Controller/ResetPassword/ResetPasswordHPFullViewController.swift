//
//  ResetPasswordHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class ResetPasswordHPFullViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var sentToLbl: UILabel!
    @IBOutlet weak var timeDisclaimerLbl: UILabel!
    @IBOutlet weak var pinView: PinInputView!
    @IBOutlet weak var validateBtn: UIButton!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var warningErrorLbl: UILabel!

    private let disposeBag = DisposeBag()

    var selectedView: ShowResetPasswordView = .temporalCode {
        didSet {
            initView()
        }
    }
    var tmpPin : String?
    var firstPin : String?
    var secondPin : String?
    var codeSentTo = ""
    var recoverType = ""

    lazy var viewModel: ResetPasswordViewModel = {
        return ResetPasswordViewModel()
    }()
    
    @objc func didTapOnDismissKeyboardAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedView = .temporalCode
        configurePin()
        configViewModel()
        configureResendBtn()

        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnDismissKeyboardAction(_:)))
        dismissTap.numberOfTapsRequired = 1
        dismissTap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(dismissTap)
    }

    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }

    func configurePin(){
        pinView.delegate = self
        pinView.textColor = UIColor.black
        pinView.bottomBorderColor = UIColor.black
        pinView.keyboardType = UIKeyboardType.numberPad
        pinView.nextDigitBottomBorderColor = UIColor(hexString: "979797")!
        pinView.hideWarning = hideWarning
    }
    
    func configureResendBtn() {
        resendCodeBtn.backgroundColor = .clear
        resendCodeBtn.layer.cornerRadius = 13
        resendCodeBtn.layer.borderWidth = 1.0
        resendCodeBtn.layer.borderColor = UIColor.lightGray1.cgColor
    }

    func hideWarning(){
        errorView.isHidden = true
    }

    private func validateInputCode() {
        let text = self.pinView.text
        if text.count < 4 {
            return
        }

        self.dismissKeyboard()
    }

    func initView() {
        switch selectedView {
        case .temporalCode:
            validateBtn.makeHugoButton(title: "hp_full_reset_pin_validate_button".localizedString)
            titleLbl.text = "hp_full_reset_pin_title".localizedString
            subTitleLbl.text = "hp_full_reset_pin_subtitle".localizedString
            sentToLbl.text = codeSentTo
            timeDisclaimerLbl.text = "hp_full_reset_pin_time_disclaimer".localizedString
            resendCodeBtn.setTitle("hp_full_reset_pin_resend_code".localizedString, for: .normal) 
            resendCodeBtn.isHidden = false
            resendCodeBtn.isUserInteractionEnabled = true
        case .setNewCode:
            validateBtn.makeHugoButton(title: "hp_full_reset_pin_next_button".localizedString)
            titleLbl.text = "hp_full_reset_pin_newpin_title".localizedString
            subTitleLbl.text = "hp_full_reset_pin_newpin_subtitle".localizedString
            sentToLbl.text = ""
            timeDisclaimerLbl.text = ""
            resendCodeBtn.isHidden = true
            resendCodeBtn.isUserInteractionEnabled = false
        case .verifyNewCode:
            validateBtn.makeHugoButton(title: "hp_full_reset_pin_confirm_button".localizedString)
            titleLbl.text = ("\("hp_full_reset_pin_newpin_confirmation_title".localizedString)")
            subTitleLbl.text = "hp_full_reset_pin_newpin_confirmation_subtitle".localizedString
            sentToLbl.text = ""
            timeDisclaimerLbl.text = ""
            resendCodeBtn.isHidden = true
            resendCodeBtn.isUserInteractionEnabled = false
        }
        
        pinView.viewBecomeFirstResponder()
    }
    
    func doResendPinRecoveryCode(recoverType: String) {
        showLoading()
        viewModel.resendPinRecoveryCode(recoverMethodType: recoverType).asObservable()
        .subscribe(onNext: {[weak self] (blockUserData) in
            guard let blockUserData = blockUserData else { return }
            DispatchQueue.main.async {
                self?.hideLoading()
                if let success = blockUserData.success, success {
                    
                }else {
                    if let msg = blockUserData.message {
                        showErrorCustom("Error", msg)
                    } else {
                        showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    }
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    @IBAction func didTapResendCode(_ sender: Any) {
        self.doResendPinRecoveryCode(recoverType: recoverType)
    }
    
    @IBAction func validatePin(_ sender: Any) {
        switch selectedView {
        case .temporalCode:
            actionValidatePin()
        case .setNewCode:
            setNewPinCode()
        case .verifyNewCode:
            setVerifyNewPinCode()
        }
    }

    func actionValidatePin() {
        if self.pinView.text.count == 4 {
            tmpPin = self.pinView.text
            if let tmpPin = tmpPin {
                doVerifyTempCode(inputCode: Int(tmpPin) ?? 0)
            }
        } else {
            showWarningBadPin()
        }
    }

    func setNewPinCode() {
        if self.pinView.text.count == 4 {
            firstPin = self.pinView.text
            selectedView = .verifyNewCode
        } else {
            showWarningBadPin()
        }
    }

    func setVerifyNewPinCode() {
        if self.pinView.text.count == 4, let first = firstPin {
            secondPin = pinView.text
            if secondPin == first {
                doRegistration(pin: first)
            } else {
                showWarning()
            }
        } else {
            showWarningBadPin()
        }
    }

    func showWarningBadPin(){
        let attributedString = NSMutableAttributedString(string: "Ingresa un PIN válido de 4 digitos", attributes: [
          .font: UIFont(name: "GothamHTF-Book", size: 13.0)!,
          .foregroundColor: UIColor(red: 128.0 / 255.0, green: 107.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
        ])
        warningErrorLbl.attributedText = attributedString
        errorView.isHidden = false
    }

    func showWarning(){
        let attributedString = NSMutableAttributedString(string: "PIN incorrecto, Intenta de nuevo", attributes: [
          .font: UIFont(name: "GothamHTF-Bold", size: 13.0)!,
          .foregroundColor: UIColor(red: 128.0 / 255.0, green: 107.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "GothamHTF-Book", size: 13.0)!, range: NSRange(location: 0, length: 15))
        warningErrorLbl.attributedText = attributedString
        errorView.isHidden = false
    }

    func resetPin(){
        self.pinView.cleanLabels()
    }

    @IBAction func goBack(_ sender: Any) {
        switch selectedView {
        case .temporalCode:
            dismiss(animated: true, completion: nil)
        case .setNewCode:
            selectedView = .temporalCode
        case .verifyNewCode:
            selectedView = .setNewCode
        }
    }

    func doVerifyTempCode(inputCode: Int) {
        showLoading()
        viewModel.validateTempCode(tempCode: inputCode).asObservable()
        .subscribe(onNext: {[weak self] (validateTempCode) in
            guard let validateTempCode = validateTempCode else { return }
            DispatchQueue.main.async {
                self?.hideLoading()
                self?.resetPin()
                if let success = validateTempCode.data?.valid, success {
                    self?.selectedView = .setNewCode
                } else {
                    if let code = validateTempCode.code, code == 1006{
                        self?.showWarning()
                    } else if let msg = validateTempCode.message {
                        showErrorCustom("Error", msg)
                    } else {
                        showGeneralErrorCustom(ErrorCodes.HugoPay.Login.VerifyPinFail)
                    }
                }
            }
        })
        .disposed(by: disposeBag)
    }

    func doRegistration(pin : String){
        showLoading()
            viewModel.registerPin(pin).asObservable()
                .subscribe(onNext: {[weak self] (providersdata) in
                    guard let providersdata = providersdata else { return }
                    DispatchQueue.main.async {
                        self?.hideLoading()
                        if let success = providersdata.success, success {
                            self?.goToHugoPay()
                        } else {
                            if let msg = providersdata.message {
                                showErrorCustom("Error", msg)
                            } else {
                                showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                            }
                        }
                    }
                })
                .disposed(by: disposeBag)
    }

    func goToHugoPay() {
        self.dismiss(animated: true) {
            self.delegate?.dismiss()
        }
    }
}

extension ResetPasswordHPFullViewController: PinInputViewDelegate {
    func pinDidChange(pinInputView: PinInputView) {
        validateInputCode()
    }
}

