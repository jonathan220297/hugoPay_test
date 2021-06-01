//
//  VerifyPinHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import LocalAuthentication

class VerifyPinHPFullViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    @IBOutlet weak var verifyPinLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var warningErrorLbl: UILabel!
    @IBOutlet weak var pinView: PinInputView!

    private let disposeBag = DisposeBag()

    lazy var viewModel: VerifyPinViewModel = {
        return VerifyPinViewModel()
    }()

    private let INTENTENS_NUMBER = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePin()
        configViewModel()

        self.pinView.viewBecomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isBiometric() && !viewModel.isBlock() {
            startBiometric()
        }
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func configurePin(){
        self.pinView.delegate = self
        self.pinView.textColor = UIColor.black
        self.pinView.bottomBorderColor = UIColor.black
        self.pinView.keyboardType = UIKeyboardType.numberPad
        self.pinView.nextDigitBottomBorderColor = UIColor(hexString: "979797")!
        self.pinView.hideWarning = hideWarning

        self.verifyPinLabel.text = "Ingresa tu PIN de acceso".localizedString
    }

    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
        viewModel.resetPin = { [weak self] () in
            self?.resetPin()
        }
    }

    func hideWarning() {
        errorView.isHidden = true
    }

    func startBiometric(){
        let localAuthenticationContext = LAContext()

        var authorizationError: NSError?
        let reason = "La autenticación es necesaria para entrar"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in

                if success {
                    DispatchQueue.main.async() {
                        self.doLoginBiometrics()
                    }
                } else {
                    // Failed to authenticate
                    guard let error = evaluateError else {
                        return
                    }
                    print(error)
                }
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            print(error)
        }
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

    private func validateInputCode() {
        let text = self.pinView.text
        if text.count < 4 {
            return
        }

        doVerifyPin(pin: text)
    }

    private func resetUserIntents() {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "HugoPayUserIntents")
    }

    private func userIntents() -> Int {
        let defaults = UserDefaults.standard
        var userIntents = defaults.integer(forKey: "HugoPayUserIntents")
        userIntents += 1
        defaults.set(userIntents, forKey: "HugoPayUserIntents")
        return userIntents
    }

    func doVerifyPin(pin : String){
        dismissKeyboard()
        showLoading()
        viewModel.loginWithPin(pin).asObservable()
            .subscribe(onNext: {[weak self] (logindata) in
                guard let logindata = logindata else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = logindata.success, success {
                        self?.goToHugoPay()
                        self?.resetUserIntents()
                    } else {
                        self?.resetPin()
                        if let code = logindata.code, code == 1006 {
                            if((self?.userIntents() ?? 0) < self?.INTENTENS_NUMBER ?? 3) {
                                self?.showWarning()
                            }else {
                                self?.resetUserIntents()
                                self?.viewModel.setIsBlock(updateValue: true)
                                self?.doBlockUser()
                            }
                        } else if let msg = logindata.message {
                            showErrorCustom("Error", msg)
                        } else {
                            showGeneralErrorCustom(ErrorCodes.HugoPay.Login.VerifyPinFail)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func doBlockUser() {
        showLoading()
        viewModel.blockUserAccess().asObservable()
        .subscribe(onNext: {[weak self] (blockUserData) in
            guard let blockUserData = blockUserData else { return }
            DispatchQueue.main.async {
                self?.hideLoading()
                if let userIsBlock = blockUserData.data?.is_block, userIsBlock {
                    self?.showBlockUser()
                }
            }
        })
        .disposed(by: disposeBag)
    }

    func showBlockUser() {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.hugoPayFull.blockUserHugoPayViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }

    func doLoginBiometrics(){
        dismissKeyboard()
        showLoading()
        viewModel.loginWithBiometrics().asObservable()
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
                            showGeneralErrorCustom(ErrorCodes.HugoPay.Login.VerifyPinFail)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func resetPin(){
        self.pinView.cleanLabels()
    }

    func goToHugoPay() {
        self.dismiss(animated: true) {
            self.delegate?.dismiss()
        }
    }
}

extension VerifyPinHPFullViewController: PinInputViewDelegate {
    func pinDidChange(pinInputView: PinInputView) {
        self.validateInputCode()
    }
}
