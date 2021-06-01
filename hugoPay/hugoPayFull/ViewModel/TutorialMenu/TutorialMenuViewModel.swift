//
//  TutorialMenuViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift


class TutorialMenuViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayFullData = HugoPayFullData.shared

    var hideLoading: (()->())?
    var showLoading: (()->())?

    // SET TUTORIAL FLAGS
    func setTutorialOne(tutorialOne: Bool) {
        hugoPayFullData.showTutorialOne = tutorialOne
    }

    func setTutorialTwo(tutorialTwo: Bool) {
        hugoPayFullData.showTutorialTwo = tutorialTwo
    }

    func setTutorialThree(tutorialThree: Bool) {
        hugoPayFullData.showTutorialThree = tutorialThree
    }

    // GET TUTORIAL FLAGS
    func getTutorialOne() -> Bool {
        return hugoPayFullData.showTutorialOne
    }

    func getTutorialTwo() -> Bool {
        return hugoPayFullData.showTutorialTwo
    }

    func getTutorialThree() -> Bool {
        return hugoPayFullData.showTutorialThree
    }

     func updateTutorialThree() -> BehaviorRelay<CompleteTutorialResponse?> {
         let apiResponse: BehaviorRelay<CompleteTutorialResponse?> = BehaviorRelay(value: nil)
         apiClient.sendPutHPFull(CompleteTutorialRequest(
            client_id: userManager.client_id ?? "",
            screen_number: 3
         )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let tutorial):
                    apiResponse.accept(tutorial)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)

                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
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
                        self.setTutorialOne(tutorialOne: data[0].tutorial_1 ?? true)
                        self.setTutorialTwo(tutorialTwo: data[1].tutorial_2 ?? true)
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
