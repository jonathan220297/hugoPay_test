//
//  TutorialHugoPayFullViewModel.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 19/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TutorialHugoPayFullViewModel: NSObject {
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared

    var hideLoading: (()->())?
    var showLoading: (()->())?
    
    func getTutorialDataHugoPay() -> BehaviorRelay<HugoPayTutorialResponse?> {
         let apiResponse: BehaviorRelay<HugoPayTutorialResponse?> = BehaviorRelay(value: nil)
         apiClient.sendGetHPFull(HugoPayFullTutorialRequest()) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let tutorialData):
                    apiResponse.accept(tutorialData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func getTutorialStatus() -> BehaviorRelay<TutorialStepsResponse?> {
         let apiResponse: BehaviorRelay<TutorialStepsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(TutorialStepsRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let steps):
                    apiResponse.accept(steps)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func updateTutorialStatus(for screen: Int, tutorialFinished: Bool? = false) -> BehaviorRelay<HugoPayTutorialUpdateStatusResponse?> {
         let apiResponse: BehaviorRelay<HugoPayTutorialUpdateStatusResponse?> = BehaviorRelay(value: nil)
         apiClient.sendPutHPFull(HugoPayTutorialUpdateStatusRequest(
            client_id: userManager.client_id ?? "",
            screen_number: screen,
            tutorial_finished: tutorialFinished ?? false
         )) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let updateData):
                    apiResponse.accept(updateData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
}
