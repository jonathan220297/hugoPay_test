//
//  CashInMoneyIncomeViewModel.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class CashInMoneyIncomeViewModel: NSObject {
    private let apiClient: APIClient = APIClient()
    let userManager = UserManager.shared
    
    var hideLoading: (()->())?
    var showLoading: (()->())?
    var showMessage: ((_ text: String) -> ())?
    
    func verifyMoneyInfo(with moneyIncomeText: String, minimumAmount: Int) -> Bool {
        let moneyIncome = moneyIncomeText.replacingOccurrences(of: userManager.symbol ?? "$", with: "")
        if moneyIncome.isEmpty {
            print("Valor vacio")
            let text = "hp_CashInMoneyIncome_AmountRequired".localized
            self.showMessage!(text)
            return false
        }
        if let moneyIncomeInt = Double(moneyIncome) {
            if moneyIncomeInt < Double(minimumAmount) {
                print("Valor menor a \(minimumAmount)")
                let text = "hp_CashInMoneyIncome_MinimumAmountValidation".localized + "\(userManager.symbol ?? "")\(minimumAmount)"
                self.showMessage!(text)
                return false
            }
        }
        return true
    }
    
    func fetchCashInConfiguration() -> BehaviorRelay<CashinConfigurationResponse?> {
        let apiResponse: BehaviorRelay<CashinConfigurationResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(CashinConfigurationRequest(
            country: userManager.country_code ?? "SV"
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let configuration):
                    apiResponse.accept(configuration)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
}
