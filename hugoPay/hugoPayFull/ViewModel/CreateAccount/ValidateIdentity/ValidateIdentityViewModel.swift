//
//  ValidateIdentityViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 19/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ValidateIdentityViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    let userManager = UserManager.shared

    var hideLoading:(()->())?
    var showLoading:(()->())?

    func createAccountHPFull() -> BehaviorRelay<CreateCacaoAccountResponse?> {
        let apiResponse: BehaviorRelay<CreateCacaoAccountResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostCacaoHPFull(CreateCacaoAccountRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let blockCCHPFull):
                    apiResponse.accept(blockCCHPFull)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
}
