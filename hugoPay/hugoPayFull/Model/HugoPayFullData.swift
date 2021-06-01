//
//  HugoPayFullData.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class HugoPayFullData: NSObject {

    static let shared = HugoPayFullData()
    
    var hugoPayFullInit : InitDataHPFull?
    var hugoPayTutorialTexts: [TutorialTextsHugoPay]?
        
    var filterDateStart: String?
    var filterDateEnd: String?
    
    var existPendingTransaction: Bool?
    
    var use_cashback : Bool?
    var cashback_amount : Double?
    var active_transaction_id : String?
    var screen_brightness: CGFloat?
    
    var activeTransactionData : DataTransactionHugoPay?

    // TUTORIAL FLAGS
    var showTutorialOne = true
    var showTutorialTwo = true
    var showTutorialThree = true
    
    // MARK: - HugoPayFullTransactionsFilters
    var withHugoPayFullFilters = false
    var startDateHPFFilter: String?
    var endDateHPFFilter: String?
    var movementTypeHPFFilter: String?
    var startAmountHPFFilter: Double?
    var endAmountHPFFilter: Double?
    var paymentTypeHPFFilter: String?
    
    func resetFPFFilters() {
        startDateHPFFilter = nil
        endDateHPFFilter = nil
        movementTypeHPFFilter = nil
        startAmountHPFFilter = nil
        endAmountHPFFilter = nil
        paymentTypeHPFFilter = nil
        withHugoPayFullFilters = false
    }
    
    // MARK: - Safe Area Margins
    
    static func hasTopNotch() -> CGFloat {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0
        }
        
        return 20.0
    }
    
    static func hasBottomArea() -> CGFloat {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0
        }
        
        return 0.0
    }
}
