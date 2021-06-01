//
//  TransactionFiltersViewModel.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 19/4/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

class TransactionFiltersViewModel: NSObject {
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared
    
    var hideLoading: (()->())?
    var showLoading: (()->())?
    var showErrorMessage: ((_ message: String)->())?
    
    func setStartDate(_ start : String?){
        hugoPayData.startDateHPFFilter = start
    }

    func setEndDate(_ start : String?){
        hugoPayData.endDateHPFFilter = start
    }
    
    func setTransactionType(with type: String?) {
        hugoPayData.movementTypeHPFFilter = type
    }
    
    func setMinAmountFilter(with amount: Double?) {
        hugoPayData.startAmountHPFFilter = amount
    }
    
    func setMaxAmountFilter(with amount: Double?) {
        hugoPayData.endAmountHPFFilter = amount
    }
    
    func setPaymentType(with type: String?) {
        hugoPayData.paymentTypeHPFFilter = type
    }

    func cleanFilters(){
        hugoPayData.resetFPFFilters()
    }
    
    func verifyFormData(with minAmountStr: String, _ maxAmountStr: String) -> Bool {
        if minAmountStr != "" && maxAmountStr != "" {
            let minAmount = minAmountStr.removeFormatAmount()
            let maxAmount = maxAmountStr.removeFormatAmount()
            if minAmount > maxAmount {
                showErrorMessage?("El monto mínimo no puede ser mayor al monto máximo")
                return false
            }
        }
        return true
    }
}
