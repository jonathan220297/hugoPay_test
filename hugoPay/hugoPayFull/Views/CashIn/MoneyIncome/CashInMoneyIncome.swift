//
//  CashInMoneyIncome.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 23/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift

class CashInMoneyIncome: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var labelMoneyIncome: UILabel!
    @IBOutlet weak var labelMinimumAmount: LocalizableLabel!
    @IBOutlet weak var labelErrorAmount: UILabel!
    
    lazy var viewModel: CashInMoneyIncomeViewModel = {
        return CashInMoneyIncomeViewModel()
    }()
    
    var view: UIView!
    var pullUpView: PullUpView!
    
    var goCashInMoneyConfirmation : ((_ amount: Double?)->())?
    var tf: UITextField?
    
    let disposeBag = DisposeBag()
    var minimumAmount = 0
    
    func removeViews() {
        guard let view = self.view else { return }
        view.endEditing(true)
        view.removeFromSuperview()
    }

    func prepareViews(_ vc_view: PullUpView) {
        let nib = Bundle.main.loadNibNamed("CashInMoneyIncome", owner: self, options: nil)
        
        if let view = nib?.first as? UIView {
            pullUpView = vc_view
            vc_view.addSubview(view)
            let newHeight = vc_view.frame.height
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            let labelMoneyIncomeTap = UITapGestureRecognizer(target: self, action: #selector(labelMoneyIncomeTapped))
            labelMoneyIncomeTap.numberOfTapsRequired = 1
            self.labelMoneyIncome.addGestureRecognizer(labelMoneyIncomeTap)
            self.labelMoneyIncome.isUserInteractionEnabled = true
            
            //Notifications
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            self.configureViewModel()
            self.fetchCashinConfiguration()
            
            view.frame = CGRect(x: 0, y: 0, width: vc_view.frame.width, height: newHeight)
            view.backgroundColor = .clear
            
            self.view = view
        }
    }
    
    // MARK: - Observers
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        if let viewWithTag = self.view.viewWithTag(12123232) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.pullUpView.updateHeight(with: 350 + keyboardSize.height)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.pullUpView.updateHeight(with: 350)
    }
    
    @objc func labelMoneyIncomeTapped() {
        tf = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tf?.viewWithTag(12123232)
        self.view.addSubview(tf!)
        tf!.addTarget(self, action: #selector(textFieldMoneyDidChange), for: .editingChanged)
        tf!.keyboardType = .numberPad
        tf!.becomeFirstResponder()
        tf?.text = labelMoneyIncome.text?.replacingOccurrences(of: viewModel.userManager.symbol ?? "$", with: "")
    }
    
    @objc func textFieldMoneyDidChange(_ textField: UITextField) {
        print(textField.text)
        if textField.text!.isEmpty {
            labelMoneyIncome.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            tf?.text = labelMoneyIncome.text?.replacingOccurrences(of: viewModel.userManager.symbol ?? "$", with: "")
        } else if textField.text! == "0.00" || textField.text! == "0.0" || textField.text! == "0.000" {
            labelMoneyIncome.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            tf?.text = "0.00"
        } else if let amountString = textField.text?.currencyInputFormatting(with: viewModel.userManager.symbol ?? "$") {
            labelMoneyIncome.text = amountString
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonNextTapped(_ sender: Any) {
        resetLabelError()
        let moneyIncome = labelMoneyIncome.text!
        if viewModel.verifyMoneyInfo(with: moneyIncome, minimumAmount: minimumAmount) {
            let moneyIncome = labelMoneyIncome.text!.removeFormatAmount()
            let moneyIncomeDouble = Double(moneyIncome)
            goCashInMoneyConfirmation?(moneyIncomeDouble)
        }
    }
    
    // MARK: - Functions
    fileprivate func configureViewModel() {
        viewModel.showMessage = {[weak self] message in
            self?.labelErrorAmount.isHidden = false
            self?.labelErrorAmount.text = message
        }
    }
    
    fileprivate func resetLabelError() {
        self.labelErrorAmount.isHidden = true
    }
    
    fileprivate func fetchCashinConfiguration() {
        viewModel.fetchCashInConfiguration()
            .asObservable()
            .subscribe(onNext: {[weak self] response in
                guard let response = (response) else { return }
                if let sucess = response.success, sucess, let data = response.data {
                    self?.labelMinimumAmount.text = "hp_CashInMoneyIncome_MinimumAmount".localized + (data.minAmountLabel ?? "")
                    self?.minimumAmount = data.minAmount ?? 0
                }
            })
            .disposed(by: disposeBag)
    }
}
