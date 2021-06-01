//
//  CreateBiometricsHPFullViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 19/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class CreateBiometricsHPFullViewModel: NSObject {
    
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayFullData = HugoPayFullData.shared

    var hideLoading: (()->())?
    var showLoading: (()->())?

    func updateBiometrics(_ active : Bool) -> BehaviorRelay<BiometricsHugoPayFullResponse?> {
         let apiResponse: BehaviorRelay<BiometricsHugoPayFullResponse?> = BehaviorRelay(value: nil)
         apiClient.sendPostHPFull(BiometricsHugoPayFullRequest(
            client_id: userManager.client_id ?? "",
            app_id: UIDevice.current.identifierForVendor?.uuidString ?? "",
            biometrics: active
         )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let payservices):
                    apiResponse.accept(payservices)
                    self.hugoPayFullData.hugoPayFullInit?.biometrics = active
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
}
