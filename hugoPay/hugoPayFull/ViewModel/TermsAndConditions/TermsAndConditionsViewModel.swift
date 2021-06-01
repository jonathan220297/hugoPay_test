//
//  TermsAndConditionsViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift


class TermsAndConditionsViewModel: NSObject {
    
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayFullData = HugoPayFullData.shared
    
    var hideLoading: (()->())?
    var showLoading: (()->())?

     func updateAcceptedTerms(_ active : Bool) -> BehaviorRelay<AcceptTermsHugoPayResponse?> {
         let apiResponse: BehaviorRelay<AcceptTermsHugoPayResponse?> = BehaviorRelay(value: nil)
         apiClient.sendPostHP(DoAcceptTermsHugoPay(
            client_id: userManager.client_id ?? ""
         )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let payservices):
                    apiResponse.accept(payservices)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
}
