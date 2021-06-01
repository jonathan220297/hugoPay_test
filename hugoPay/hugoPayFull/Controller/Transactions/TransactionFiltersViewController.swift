//
//  TransactionFiltersViewController.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 16/4/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class TransactionFiltersViewController: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelDateFilter: UILabel!
    @IBOutlet weak var viewStartDate: UIView!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var viewEndDate: UIView!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var labelTransactionFilter: UILabel!
    @IBOutlet weak var viewMoneyIncome: UIView!
    @IBOutlet weak var buttonMoneyIncome: UIButton!
    @IBOutlet weak var viewMoneyExpenses: UIView!
    @IBOutlet weak var buttonMoneyExpenses: UIButton!
    @IBOutlet weak var labelAmountFilter: UILabel!
    @IBOutlet weak var viewMinAmount: UIView!
    @IBOutlet weak var textFieldMinAmount: UITextField!
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var viewMaxAmount: UIView!
    @IBOutlet weak var textFieldMaxAmount: UITextField!
    @IBOutlet weak var labelPaymentsMethods: UILabel!
    @IBOutlet weak var buttonOtherCards: UIButton!
    @IBOutlet weak var buttonHugoPay: UIButton!
    @IBOutlet weak var buttonAlls: UIButton!
    @IBOutlet weak var buttonApply: UIButton!
    
    var customPickerView: DayMonthYearPickerView?
    
    lazy var viewModel: TransactionFiltersViewModel = {
        return TransactionFiltersViewModel()
    }()
    
    var transactionMovementType: TransactionFullMovementType?
    var transactionPaymentType: TransactionPaymentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureViews()
        configureFilters()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Observers
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func setStartDate(){
        self.view.endEditing(true)
        
    }
    @objc func setEndDate(){
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let cur = textField.text!.currencyInputFormatting(with: UserManager.shared.symbol ?? "$")
        textField.text = cur
    }
    
    // MARK: - Actions
    @IBAction func buttonCloseTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonCleanTapped(_ sender: Any) {
        viewModel.hugoPayData.resetFPFFilters()
        textFieldEndDate.text = ""
        textFieldStartDate.text = ""
        textFieldMinAmount.text = ""
        textFieldMaxAmount.text = ""
        buttonMoneyIncome.backgroundColor = .white
        buttonMoneyExpenses.backgroundColor = .white
        buttonMoneyIncome.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        buttonMoneyExpenses.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        buttonOtherCards.backgroundColor = .white
        buttonHugoPay.backgroundColor = .white
        buttonAlls.backgroundColor = .white
        buttonOtherCards.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        buttonHugoPay.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        buttonAlls.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        transactionMovementType = nil
        transactionPaymentType = nil
    }
    
    @IBAction func buttonIncomeTapped(_ sender: UIButton) {
        setTransactionType(sender)
    }
    
    @IBAction func buttonExpensesTapped(_ sender: UIButton) {
        setTransactionType(sender)
    }
    
    @IBAction func buttonPaymentMethodsTapped(_ sender: UIButton) {
        setPaymentMethod(sender)
    }
    
    @IBAction func buttonApplyTapped(_ sender: Any) {
        let minAmountStr = textFieldMinAmount.text!
        let maxAmountStr = textFieldMaxAmount.text!
        if viewModel.verifyFormData(with: minAmountStr, maxAmountStr) {
            viewModel.setStartDate(textFieldStartDate.text)
            viewModel.setEndDate(textFieldEndDate.text)
            viewModel.setTransactionType(with: transactionMovementType?.rawValue)
            if let minAmountStr = textFieldMinAmount.text,
               let maxAmountStr = textFieldMaxAmount.text {
                let minAmount = minAmountStr.removeFormatAmount()
                let maxAmount = maxAmountStr.removeFormatAmount()
                if minAmount != 0.0 && maxAmount != 0.0 {
                    viewModel.setMinAmountFilter(with: minAmount)
                    viewModel.setMaxAmountFilter(with: maxAmount)
                }
            }
            //            viewModel.setPaymentType(with: transactionPaymentType?.rawValue)
            viewModel.hugoPayData.withHugoPayFullFilters = true
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Functions
    fileprivate func configureViews() {
        viewStartDate.layer.borderWidth = 1.0
        viewStartDate.layer.borderColor = UIColor.transactionFilterLine.cgColor
        viewStartDate.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        viewEndDate.layer.borderWidth = 1.0
        viewEndDate.layer.borderColor = UIColor.transactionFilterLine.cgColor
        viewEndDate.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        viewMoneyIncome.layer.borderWidth = 1.0
        viewMoneyIncome.layer.borderColor = UIColor.transactionFilterLine.cgColor
        viewMoneyIncome.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        viewMoneyExpenses.layer.borderWidth = 1.0
        viewMoneyExpenses.layer.borderColor = UIColor.transactionFilterLine.cgColor
        viewMoneyExpenses.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        viewMinAmount.layer.borderWidth = 1.0
        viewMinAmount.layer.borderColor = UIColor.transactionFilterLine.cgColor
        viewMinAmount.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        viewMaxAmount.layer.borderWidth = 1.0
        viewMaxAmount.layer.borderColor = UIColor.transactionFilterLine.cgColor
        viewMaxAmount.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        buttonOtherCards.layer.borderWidth = 1.0
        buttonOtherCards.layer.borderColor = UIColor.transactionFilterLine.cgColor
        buttonOtherCards.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        buttonHugoPay.layer.borderWidth = 1.0
        buttonHugoPay.layer.borderColor = UIColor.transactionFilterLine.cgColor
        buttonHugoPay.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        buttonAlls.layer.borderWidth = 1.0
        buttonAlls.layer.borderColor = UIColor.transactionFilterLine.cgColor
        buttonAlls.layer.cornerRadius = viewStartDate.frame.size.height / 2.5
        
        buttonApply.makeHugoButton(title: "hp_lbl_transaction_filter_title".localizedString.uppercased())
        textFieldStartDate.placeholder = "hp_full_TransactionFiltersViewController_TransactionDateInit".localized
        textFieldEndDate.placeholder = "hp_full_TransactionFiltersViewController_TransactionDateEnd".localized
        textFieldMinAmount.placeholder = "hp_full_TransactionFiltersViewController_TransactionAmountMin".localized
        textFieldMaxAmount.placeholder = "hp_full_TransactionFiltersViewController_TransactionAmountMax".localized
        
        textFieldStartDate.delegate = self
        textFieldEndDate.delegate = self
        textFieldMinAmount.delegate = self
        textFieldMaxAmount.delegate = self
        configureDatePickerTextfield()
        
        textFieldMinAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldMaxAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    fileprivate func configureFilters() {
        if let startDate = viewModel.hugoPayData.startDateHPFFilter {
            textFieldStartDate.text = startDate
        }
        if let endDate = viewModel.hugoPayData.endDateHPFFilter {
            textFieldEndDate.text = endDate
        }
        if let movementType = viewModel.hugoPayData.movementTypeHPFFilter {
            switch movementType {
            case TransactionFullMovementType.inc.rawValue:
                buttonMoneyIncome.backgroundColor = UIColor.transactionFilterSelected
                buttonMoneyIncome.setTitleColor(.white, for: .normal)
                transactionMovementType = .inc
                break
            case TransactionFullMovementType.exp.rawValue:
                buttonMoneyExpenses.backgroundColor = UIColor.transactionFilterSelected
                buttonMoneyExpenses.setTitleColor(.white, for: .normal)
                transactionMovementType = .exp
                break
            default:
                break
            }
        }
        if let minAmount = viewModel.hugoPayData.startAmountHPFFilter {
            print("minAmount: \(minAmount)")
            textFieldMinAmount.text = String(format: "%.02f", minAmount).currencyInputFormatting(with: UserManager.shared.symbol ?? "$")
        }
        if let maxAmount = viewModel.hugoPayData.endAmountHPFFilter {
            print("maxAmount: \(maxAmount)")
            textFieldMaxAmount.text = String(format: "%.02f", maxAmount).currencyInputFormatting(with: UserManager.shared.symbol ?? "$")
        }
        if let paymentType = viewModel.hugoPayData.paymentTypeHPFFilter {
            switch paymentType {
            case TransactionPaymentType.other.rawValue:
                buttonOtherCards.backgroundColor = UIColor.transactionFilterSelected
                buttonOtherCards.setTitleColor(.white, for: .normal)
                transactionPaymentType = .other
                break
            case TransactionPaymentType.hugoPay.rawValue:
                buttonHugoPay.backgroundColor = UIColor.transactionFilterSelected
                buttonHugoPay.setTitleColor(.white, for: .normal)
                transactionPaymentType = .hugoPay
                break
            case TransactionPaymentType.all.rawValue:
                buttonAlls.backgroundColor = UIColor.transactionFilterSelected
                buttonAlls.setTitleColor(.white, for: .normal)
                transactionPaymentType = .all
                break
            default:
                break
            }
        }
    }
    
    func configureViewModel() {
        viewModel.showLoading = {[weak self] in
            self?.showLoading()
        }
        viewModel.hideLoading = {[weak self] in
            self?.hideLoading()
        }
        viewModel.showErrorMessage = {[weak self] message in
            self?.simpleAlert(title: "hugoPay", message: message)
        }
    }
    
    func configureDatePickerTextfield() {
        addEndDatePicker()
        addStartDatePicker()
    }
    
    fileprivate func addEndDatePicker() {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "hp_lbl_transaction_filter_done".localizedString, style: .plain, target: self, action: #selector(setEndDate));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "hp_lbl_transaction_filter_cancel".localizedString, style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        customPickerView = DayMonthYearPickerView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 300)))
        customPickerView?.onDateSelected = { (day: Int, month: Int, year: Int) in
            self.textFieldEndDate.text = String(format: "%d/%02d/%d", day, month, year)
        }
        
        textFieldEndDate.inputAccessoryView = toolbar
        textFieldEndDate.inputView = customPickerView
    }
    
    fileprivate func addStartDatePicker() {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "hp_lbl_transaction_filter_done".localizedString, style: .plain, target: self, action: #selector(setStartDate));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "hp_lbl_transaction_filter_cancel".localizedString, style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        customPickerView = DayMonthYearPickerView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 300)))
        customPickerView?.onDateSelected = { (day: Int, month: Int, year: Int) in
            self.textFieldStartDate.text = String(format: "%d/%02d/%d", day, month, year)
        }
        
        textFieldStartDate.inputAccessoryView = toolbar
        textFieldStartDate.inputView = customPickerView
    }
    
    fileprivate func setTransactionType(_ sender: UIButton) {
        buttonMoneyIncome.backgroundColor = .white
        buttonMoneyExpenses.backgroundColor = .white
        buttonMoneyIncome.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        buttonMoneyExpenses.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        if sender == buttonMoneyIncome {
            buttonMoneyIncome.backgroundColor = UIColor.transactionFilterSelected
            buttonMoneyIncome.setTitleColor(.white, for: .normal)
            transactionMovementType = .inc
        }
        if sender == buttonMoneyExpenses {
            buttonMoneyExpenses.backgroundColor = UIColor.transactionFilterSelected
            buttonMoneyExpenses.setTitleColor(.white, for: .normal)
            transactionMovementType = .exp
        }
    }
    
    fileprivate func setPaymentMethod(_ sender: UIButton) {
        buttonOtherCards.backgroundColor = .white
        buttonHugoPay.backgroundColor = .white
        buttonAlls.backgroundColor = .white
        buttonOtherCards.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        buttonHugoPay.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        buttonAlls.setTitleColor(UIColor(named: "DeepPurple")!, for: .normal)
        if sender == buttonOtherCards {
            buttonOtherCards.backgroundColor = UIColor.transactionFilterSelected
            buttonOtherCards.setTitleColor(.white, for: .normal)
            transactionPaymentType = .other
        }
        if sender == buttonHugoPay {
            buttonHugoPay.backgroundColor = UIColor.transactionFilterSelected
            buttonHugoPay.setTitleColor(.white, for: .normal)
            transactionPaymentType = .hugoPay
        }
        if sender == buttonAlls {
            buttonAlls.backgroundColor = UIColor.transactionFilterSelected
            buttonAlls.setTitleColor(.white, for: .normal)
            transactionPaymentType = .all
        }
    }
}

extension TransactionFiltersViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldStartDate {
            if textFieldStartDate.text?.isEmpty ?? false {
                self.textFieldStartDate.text = String(format: "%d/%02d/%d", customPickerView?.day ?? 0, customPickerView?.month ?? 0, customPickerView?.year ?? 0)
            }
            customPickerView?.isHidden = false
        }else if textField == textFieldEndDate {
            if textFieldEndDate.text?.isEmpty ?? false {
                self.textFieldEndDate.text = String(format: "%d/%02d/%d", customPickerView?.day ?? 0, customPickerView?.month ?? 0, customPickerView?.year ?? 0)
            }
            customPickerView?.isHidden = false
        }
        
        return true
    }
}
