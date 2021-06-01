//
//  CreatePinHPFullViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class CreatePinHPFullViewModel: NSObject {
    
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    
    var hideLoading: (()->())?
    var showLoading: (()->())?
    
    func registerPin(_ pin : String) -> BehaviorRelay<RegisterPinHPFullResponse?> {
        let apiResponse: BehaviorRelay<RegisterPinHPFullResponse?> = BehaviorRelay(value: nil)
        let aes = AES()
        
        if let encrypted = aes?.encrypt(string: pin) {
            apiClient.sendPostHPFull(RegisterPinHPFullRequest(
                pin: encrypted.base64EncodedString(),
                client_id: userManager.client_id ?? ""
            )) { response in
                switch response {
                case .success(let payservices):
                    apiResponse.accept(payservices)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.hideLoading?()
                        showGeneralErrorCustom(ErrorCodes.HugoPay.Login.VerifyPinFail)
                    }
                    print(error.localizedDescription)
                }
            }
        }
        
        return apiResponse
    }
    
}
