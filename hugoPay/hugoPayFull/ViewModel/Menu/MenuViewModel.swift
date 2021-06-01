//
//  MenuViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 03/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift


class MenuViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayFullData = HugoPayFullData.shared

    var hideLoading: (()->())?
    var showLoading: (()->())?

    // SET TUTORIAL FLAGS

    func setTutorialThree(tutorialThree: Bool) {
        hugoPayFullData.showTutorialThree = tutorialThree
    }

    // GET TUTORIAL FLAGS

    func getTutorialThree() -> Bool {
        return hugoPayFullData.showTutorialThree
    }

    func getTutorialSteps() -> BehaviorRelay<TutorialStepsResponse?> {
         let apiResponse: BehaviorRelay<TutorialStepsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(TutorialStepsRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let steps):
                    if let data = steps.data {
                        self.setTutorialThree(tutorialThree: data[2].tutorial_3 ?? true)
                    }
                    apiResponse.accept(steps)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
}
