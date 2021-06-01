//
//  VerifyPinViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class VerifyPinViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared

    var hideLoading:(()->())?
    var showLoading:(()->())?
    var resetPin:(()->())?

    func isBiometric() -> Bool {
        return hugoPayData.hugoPayFullInit?.biometrics ?? false
    }

    func isBlock() -> Bool{
        return hugoPayData.hugoPayFullInit?.is_block ?? false
    }

    func setIsBlock(updateValue: Bool) {
        hugoPayData.hugoPayFullInit?.is_block = updateValue
    }

    func loginWithPin(_ pin : String) -> BehaviorRelay<VerifyPinResponse?> {
        let apiResponse: BehaviorRelay<VerifyPinResponse?> = BehaviorRelay(value: nil)
        let aes = AES()
        
        if let encrypted = aes?.encrypt(string: pin) {
            apiClient.sendPostHPFull(VerifyPinRequest(
                client_id: userManager.client_id ?? "",
                pin: encrypted.base64EncodedString(),
                biometrics: false,
                app_id: UIDevice.current.identifierForVendor?.uuidString ?? ""
            )) { response in
                switch response {
                case .success(let login):
                    apiResponse.accept(login)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.hideLoading?()
                        self.resetPin?()
                        showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    }
                    print(error.localizedDescription)
                }
            }
        }
        
        return apiResponse
    }

    func loginWithBiometrics() -> BehaviorRelay<VerifyPinResponse?> {
        let apiResponse: BehaviorRelay<VerifyPinResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostHPFull(VerifyPinRequest(
            client_id: userManager.client_id ?? "",
            pin: "",
            biometrics: true,
            app_id: UIDevice.current.identifierForVendor?.uuidString ?? ""
        )) { response in
            switch response {
            case .success(let login):
                apiResponse.accept(login)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideLoading?()
                    self.resetPin?()
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                }
                print(error.localizedDescription)
            }
        }
        return apiResponse
    }

    func blockUserAccess() -> BehaviorRelay<BlockAccessHPFullResponse?> {
        let apiResponse: BehaviorRelay<BlockAccessHPFullResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostHPFull(BlockAccessHPFullRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            switch response {
            case .success(let blockUserService):
                apiResponse.accept(blockUserService)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideLoading?()
                }
                print(error.localizedDescription)
            }
        }
        return apiResponse
    }
}
