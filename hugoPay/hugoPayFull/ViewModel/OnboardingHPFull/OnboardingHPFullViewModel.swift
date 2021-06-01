//
//  OnboardingHPFullViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

class OnboardingHPFullViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    let userManager = UserManager.shared
    private var onboardingData : OnboargindHPFullResponse?

    var configureSlides: (([PageOnboardingHPFull])->())?
    var hideLoading:(()->())?
    var showLoading:(()->())?
    
    var slides: [PageOnboardingHPFull] = []
    
    func getOnboardingData() {
        apiClient.sendGetHPFull(OnboardingHPFullRequest(
            country_name: userManager.country ?? ""
        )) { response in
            switch response {
            case .success(let data):
                print(data)
                self.onboardingData = data
                DispatchQueue.main.async {
                    self.createSlides()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func getSlides() -> [PageOnboardingHPFull] {
        return self.slides
    }
    
    func countryUser() -> String{
        return userManager.country ?? ""
    }
    
    func createSlides() {
        var arraySlides = [PageOnboardingHPFull]()
        if let onboarding = onboardingData, let data = onboarding.data, !data.isEmpty {
            for slide in data {
                let slide1: PageOnboardingHPFull = Bundle.main.loadNibNamed("PageOnboardingHPFullView", owner: self, options: nil)?.first as! PageOnboardingHPFull
                slide1.setImage(slide.image)
                slide1.setTextTitle(slide.title)
                slide1.setTextMessage(slide.body)
                slide1.setExtra(slide.extra)
                arraySlides.append(slide1)
            }
        }
        slides = arraySlides
        configureSlides?(slides)
    }
}
