//
//  DetailTransactionHPFullViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class DetailTransactionHPFullViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared

    var hideLoading: (()->())?
    var showLoading: (()->())?

    var transactionHugoId: String?

    func getHPFTransactionDetails() -> BehaviorRelay<DetailTransactionHPFullResponse?> {
         let apiResponse: BehaviorRelay<DetailTransactionHPFullResponse?> = BehaviorRelay(value: nil)
         apiClient.sendGetHPFull(DetailTransactionHPFullRequest(
            hugo_id: transactionHugoId ?? ""
         )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let transactionhp):
                    apiResponse.accept(transactionhp)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }

    
    func getRequestMoneyTransactionDetails() -> BehaviorRelay<RequestMoneyTransactionDetailsResponse?> {
        let apiResponse: BehaviorRelay<RequestMoneyTransactionDetailsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(RequestMoneyTransactionDetailRequest(
           request_id: transactionHugoId ?? ""
        )) { response in
           DispatchQueue.main.async {
               self.hideLoading?()
               switch response {
               case .success(let transactionhp):
                   apiResponse.accept(transactionhp)
               case .failure(let error):
                   showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                   print(error.localizedDescription)
               }
           }
       }
        
        return apiResponse
    }
}
