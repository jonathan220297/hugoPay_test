//
//  RequestMoneyConfirmationViewModel.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/15/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class RequestMoneyConfirmationViewModel: NSObject {
    private let apiClient: APIClient = APIClient()
    let userManager = UserManager.shared
    
    var hideLoading: (()->())?
    var showLoading: (()->())?
    
    var note = ""
    var amount = ""
    
    var isNoteMissing: Bool {
        note.isEmpty || note == "hp_full_request_money_note_placeholder".localizedString
    }
    
    func configureAmountLabel(with amount: Double?) -> String {
        guard let amount = amount else { return "$0.00" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = userManager.symbol ?? "$"
        formatter.maximumFractionDigits = 2
        guard let amountString = formatter.string(from: NSNumber(value: amount)) else { return "$0.00"}
        
        return amountString
    }
    
    func updateRecipientType(for recipient: String) -> RecipientType {
        if isValidEmail(recipient) {
            return .email
        }
        let phone = recipient
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let isValid = phone.rangeOfCharacter(from: invalidCharacters,
                                             options: [],
                                             range: phone.startIndex ..< phone.endIndex) == nil
        if isValid {
            return .phone
        }
        
        return .undetermined
    }
    
    func doRequestMoney(recipientType: RecipientType,
                        recipient:String,
                        amount: Double,
                        note: String?) -> BehaviorRelay<RequestMoneyResponse?> {
        let apiResponse: BehaviorRelay<RequestMoneyResponse?> = BehaviorRelay(value: nil)
        var receiver = RequestMoneyReceiver(email: nil, phone: nil)
        
        if recipientType == .phone {
            receiver = RequestMoneyReceiver(email: nil,
                                         phone: recipient
                                            .replacingOccurrences(of: "+", with: "")
                                            .replacingOccurrences(of: " ", with: ""))
        } else if recipientType == .email {
            receiver = RequestMoneyReceiver(email: recipient, phone: nil)
        }
        
        apiClient
            .sendPostHPFull(RequestMoneyRequest(clientId: userManager.client_id ?? "",
                                             receiver: receiver,
                                             amount: amount,
                                             note: note ?? "")
            ) { response in
                DispatchQueue.main.async {
                    self.hideLoading?()
                    switch response {
                    case .success(let requestMoney):
                        apiResponse.accept(requestMoney)
                    case .failure(let error):
                        showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                        print(error.localizedDescription)
                    }
                }
            }
        
        return apiResponse
    }
}
