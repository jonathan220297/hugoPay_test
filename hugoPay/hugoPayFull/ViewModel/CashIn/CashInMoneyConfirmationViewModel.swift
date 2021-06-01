//
//  CashInMoneyConfirmationViewModel.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class CashInMoneyConfirmationViewModel: NSObject {
    private let apiClient: APIClient = APIClient()
    let cardManager = CardManager.shared
    let userManager = UserManager.shared
    let cardSelector = CreditCard()
    
    var hideLoading: (()->())?
    var showLoading: (()->())?
    
    // MARK: - Functions
    func configureInfo(with money: Double?) -> String {
        var moneyText = ""
        if let money = money {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = userManager.symbol ?? "$"
            formatter.maximumFractionDigits = 2
            if let moneyStr = formatter.string(from: NSNumber(value: money)) {
                moneyText = moneyStr
            }
        }
        return moneyText
    }
    
    func getDefaultCreditCard(completion: @escaping(CardObject?) -> ()) {
        self.userManager.getDefaultCardNew { (card) in
            DispatchQueue.main.async {
                completion(card)
            }
        }
    }
    
    func processPaymentCashIn(with amount: Double, card: CardObject) -> BehaviorRelay<ProcessCashInResponse?> {
         let apiResponse: BehaviorRelay<ProcessCashInResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostHPFull(ProcessCashInRequest(
            client_id: userManager.client_id ?? "",
            amount: amount,
            country: userManager.country_code ?? "SV",
            cc_end: card.cc_end ?? "",
            card_type: card.cc_brand ?? "",
            id_card: card.id ?? "",
            app_version: hugoVersion(),
            device_type: "IOS"
        )) { (response) in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let payment):
                    apiResponse.accept(payment)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
}
