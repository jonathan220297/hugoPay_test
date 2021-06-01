//
//  SendMoneyConfirmationViewModel.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/31/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift


class SendMoneyConfirmationViewModel: NSObject {
    private let apiClient: APIClient = APIClient()
    let userManager = UserManager.shared
    
    var hideLoading: (()->())?
    var showLoading: (()->())?
    
    func configureAmountLabel(with sendAmount: Double?) -> String {
        guard let sendAmount = sendAmount else { return "$0.00" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = userManager.symbol ?? "$"
        formatter.maximumFractionDigits = 2
        guard let sendAmountString = formatter.string(from: NSNumber(value: sendAmount)) else { return "$0.00"}
        
        return sendAmountString
    }
    
    func updateRecipientType(for recipient: String) -> RecipientType {
        if isValidEmail(recipient) {
            return .email
        }
        let phone = recipient
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: "-", with: "")
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let isValid = phone.rangeOfCharacter(from: invalidCharacters,
                                             options: [],
                                             range: phone.startIndex ..< phone.endIndex) == nil
        if isValid {
            return .phone
        }
        
        return .undetermined
    }
    
    func doSendMoney(recipientType: RecipientType,
                     recipient:String,
                     amount: Double,
                     note: String?) -> BehaviorRelay<SendMoneyResponse?> {
        let apiResponse: BehaviorRelay<SendMoneyResponse?> = BehaviorRelay(value: nil)
        var receiver = SendMoneyReceiver(email: nil, phone: nil)
        
        if recipientType == .phone {
            receiver = SendMoneyReceiver(email: nil,
                                         phone: recipient
                                            .replacingOccurrences(of: "+", with: "")
                                            .replacingOccurrences(of: " ", with: "")
                                            .replacingOccurrences(of: "(", with: "")
                                            .replacingOccurrences(of: ")", with: "")
                                            .replacingOccurrences(of: "-", with: ""))
        } else if recipientType == .email {
            receiver = SendMoneyReceiver(email: recipient, phone: nil)
        }
        
        apiClient
            .sendPostHPFull(SendMoneyRequest(clientId: userManager.client_id ?? "",
                                             receiver: receiver,
                                             amount: amount,
                                             note: note ?? "",
                                             appVersion: hugoVersion(),
                                             deviceType: "IOS")
            ) { response in
                DispatchQueue.main.async {
                    self.hideLoading?()
                    switch response {
                    case .success(let sentMoney):
                        apiResponse.accept(sentMoney)
                    case .failure(let error):
                        showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                        print(error.localizedDescription)
                    }
                }
            }
        
        return apiResponse
    }
    
    func showMessagePrompt(_ error: String) {
        let alert  = UIAlertController(title: "AProblemOcurredTitle".localizedString , message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertString.OK, style: .default, handler: nil)
        alert.addAction(action)
        
        let vc = getCurrentViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            
            return currentController
        }
        
        return nil
    }
}
