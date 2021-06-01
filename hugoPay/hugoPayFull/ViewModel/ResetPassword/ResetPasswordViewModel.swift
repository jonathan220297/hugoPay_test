//
//  ResetPasswordViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class ResetPasswordViewModel: NSObject {
    
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared
    
    var hideLoading:(()->())?
    var showLoading:(()->())?
    
    func validateTempCode(tempCode: Int) -> BehaviorRelay<ResetPasswordResponse?> {
        let apiResponse: BehaviorRelay<ResetPasswordResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostHPFull(ResetPasswordRequest(
            pin: tempCode,
            client_id: userManager.client_id ?? ""
        )) { response in
            switch response {
            case .success(let pinRecoveryService):
                apiResponse.accept(pinRecoveryService)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideLoading?()
                }
                print(error.localizedDescription)
            }
        }
        return apiResponse
    }
    
    func resendPinRecoveryCode(recoverMethodType: String) -> BehaviorRelay<PinRecoveryResponse?> {
        let apiResponse: BehaviorRelay<PinRecoveryResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostHPFull(PinRecoveryRequest(
            client_id: userManager.client_id ?? "",
            recovery_method: recoverMethodType
        )) { response in
            switch response {
            case .success(let pinRecoveryService):
                apiResponse.accept(pinRecoveryService)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideLoading?()
                }
                print(error.localizedDescription)
            }
        }
        return apiResponse
    }
    
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
