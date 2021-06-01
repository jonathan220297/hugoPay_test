//
//  BlockUserHugoPayViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class BlockUserHugoPayViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared

    var hideLoading:(()->())?
    var showLoading:(()->())?

    func getEmail() -> String {
        let email = hugoPayData.hugoPayFullInit?.email ?? ""
        let splitEmail = email.components(separatedBy: "@")
        if(splitEmail.count > 1) {
            let maskedEmail = String(splitEmail[0].enumerated().map { (index, element) -> Character in
                return index < 3 ? element : "*"
            })
            return "\(maskedEmail)@\(splitEmail[1])"
        }else {
            return ""
        }
    }

    func getPhone() -> String {
        let phone = hugoPayData.hugoPayFullInit?.phone ?? ""
        let numberLimit = phone.count - 3
        let maskedPhone = String(phone.enumerated().map { (index, element) -> Character in
            if(index < 3) {
                return element
            }else if(index < numberLimit){
                return "*"
            }else {
                return element
            }
        })
        return "\(maskedPhone)"
    }

    func pinRecoveryService(recoverMethodType: String) -> BehaviorRelay<PinRecoveryResponse?> {
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

}
