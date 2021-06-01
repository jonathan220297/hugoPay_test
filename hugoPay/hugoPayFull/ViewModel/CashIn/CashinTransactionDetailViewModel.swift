//
//  CashinTransactionDetailViewModel.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class CashinTransactionDetailViewModel: NSObject {
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared

    var hideLoading: (()->())?
    var showLoading: (()->())?

    var transactionHugoId: String?

    func getDetailTransactionHugoPay() -> BehaviorRelay<DetailTransactionHPFullResponse?> {
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
}
