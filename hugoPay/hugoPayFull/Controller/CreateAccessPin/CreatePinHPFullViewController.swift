//
//  CreatePinHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class CreatePinHPFullViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var pinView: PinInputView!
    @IBOutlet weak var validateBtn: UIButton!
    @IBOutlet weak var incorrectPinView: UIView!
    @IBOutlet weak var warningLbl: UILabel!
    
    var isVerification = false
    
    var firstPin : String?
    var secondPin : String?
    
    var fromMain = false
    
    private let disposeBag = DisposeBag()
    
    lazy var viewModel: CreatePinHPFullViewModel = {
        return CreatePinHPFullViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePin()
        configViewModel()
        initView()
        
        validateBtn.makeHugoButton(title: "ACEPTAR")
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnDismissKeyboardAction(_:)))
        dismissTap.numberOfTapsRequired = 1
        dismissTap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(dismissTap)
        
        self.pinView.viewBecomeFirstResponder()
    }
    
    @objc func didTapOnDismissKeyboardAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
        self.pinView.delegate = self
        self.pinView.textColor = UIColor.black
        self.pinView.bottomBorderColor = UIColor.black
        self.pinView.keyboardType = UIKeyboardType.numberPad
        self.pinView.nextDigitBottomBorderColor = UIColor(hexString: "979797")!
        pinView.hideWarning = hideWarning
    }
    
    func hideWarning(){
        incorrectPinView.isHidden = true
    }
    
    @IBAction func validatePin(_ sender: Any) {
        if isVerification{
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
        } else {
            if self.pinView.text.count == 4 {
                firstPin = self.pinView.text
                isVerification = true
                initView()
            } else {
                showWarningBadPin()
            }

        }
    }
    
    func initView(){
        pinView.cleanLabels()
        incorrectPinView.isHidden = true
        if isVerification {
            self.pinView.viewBecomeFirstResponder()
            titleLbl.text = "Ingresa nuevamente tu PIN".localizedString
            subTitleLbl.text = "Confirmar PIN"
        } else {
            titleLbl.text = "¡Protejamos tu cuenta!".localizedString
            subTitleLbl.text = "Ingresa un PIN de 4 dígitos.".localizedString
            
        }
    }
    
    private func validateInputCode() {
        let text = self.pinView.text
        if text.count < 4 {
            return
        }
        self.dismissKeyboard()
    }
    
    func showWarning(){
        let attributedString = NSMutableAttributedString(string: "¡Oops! El PIN ingresado es incorrecto.\nAmbos PIN’s deben ser iguales.\nIntenta de nuevo", attributes: [
          .font: UIFont(name: "GothamHTF-Book", size: 13.0)!,
          .foregroundColor: UIColor(red: 128.0 / 255.0, green: 107.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "GothamHTF-Bold", size: 13.0)!, range: NSRange(location: 70, length: 16))
        warningLbl.attributedText = attributedString
        incorrectPinView.isHidden = false
    }
    
    func showWarningBadPin(){
        let attributedString = NSMutableAttributedString(string: "Ingresa un PIN válido de 4 digitos", attributes: [
          .font: UIFont(name: "GothamHTF-Book", size: 13.0)!,
          .foregroundColor: UIColor(red: 128.0 / 255.0, green: 107.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
        ])
        warningLbl.attributedText = attributedString
        incorrectPinView.isHidden = false
    }
    
    func doRegistration(pin : String){
        showLoading()

            viewModel.registerPin(pin).asObservable()
                .subscribe(onNext: {[weak self] (providersdata) in
                    guard let providersdata = providersdata else { return }
                    DispatchQueue.main.async {
                        self?.hideLoading()
                        if let success = providersdata.success, success {
                            if self?.fromMain ?? false {
                                self?.dismiss(animated: true, completion: nil)
                            } else {
                                self?.goToPinSuccess()
                            }
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
    
    func goToHugoPay(){
        self.dismiss(animated: true) {
            self.delegate?.dismiss()
        }
    }
    
    func goToPinSuccess() {
        self.dismiss(animated: true, completion: {
            if let vc = R.storyboard.hugoPayFull.createPinSuccessHPFViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func goBack(_ sender: Any) {
        if isVerification {
            isVerification = false
            initView()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CreatePinHPFullViewController: PinInputViewDelegate {
    func pinDidChange(pinInputView: PinInputView) {
        validateInputCode()
    }
}

// MARK: - Keyboard Handling

extension CreatePinHPFullViewController {
    func registerKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(notif:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(notif: Notification) {
        guard let frame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        self.validateBtn.frame = CGRect(x: self.validateBtn.frame.origin.x, y: self.view.bounds.height - (frame.height + self.validateBtn.frame.size.height), width: self.validateBtn.frame.size.width, height: self.validateBtn.frame.size.height)
    }
    
    @objc func keyboardWillHide(notif: Notification) {
        // scrollView.contentInset = UIEdgeInsets()
    }
}
