//
//  UserManager.swift
//  HugoPay
//
//  Created by Jonathan  Rodriguez on 31/5/21.
//

import Foundation
import Parse

class UserManager: NSObject {
    
    enum InitFrom {
        case Menu
        case None
    }
    
    let userData = UserData.shared
    static let shared = UserManager()
    
    let cardManager = CardManager.shared
    
    private let apiClient: APIClient = APIClient()
    
    var player_id: String?
    var filter_selected: String?
    var cards: [Card]?
    var currentCard: CardObject?
    var cardList: [CardObject]?
    var addresses: [Address]?
    var profile_id: String?
    var profile_idInvited: String?
    var client_id: String? = "d82ktyQ4eB"
    var has_profile: Bool = false
    var name: String?
    var phone: String?
    var country_code: String?
    var last_phone: String?
    var pwd: String?
    var auth: String?
    var first_name: String?
    var last_name: String?
    var nit: String?
    var enabled: Bool?
    var email: String?
    var new_address: Address?
    var new_card: Card?
    var current_territory: String?
    var session_token: String?
    var user_id: String?
    
    var clientExists: Bool {
        return (client_id != nil)
    }
    
    var fullAddress: String?
    var address_type: Int?
    var friendly_name: String?
    var country: String?
    var is_zone_mode: Bool?
    var symbol: String?
    var currency: String?
    var dec_point: String?
    var thousands_sep: String?
    var defaultCoordinate: CLLocationCoordinate2D?
    var distance_search = 0.0
    
    var geo: String?
    var geopf: PFGeoPoint?
    var segment: String?
    var isRecentLogin: Bool = false
    var needBilling = false
    var openSetting = false
    
    var updateinvoiceZelle = false
    
    var creatingProfileFrom: String?
    var loginInitFrom: InitFrom?
    var shouldOpenFeed = false
    
    var paymentType: PaymentType? {
        didSet {
            print("paymentType set")
        }
    }
    var paymentInfo: PaymentTypeItem? {
        didSet {
            print("paymentInfo set")
        }
    }
    
    var fromScreen : String?
    var openFromSchedule : Bool = false
    var selectedPayment : Bool = false
    var deliveryTypeSelected: String?
    
    var differentTerritory = false
    var differentTerritoryId: String?
    var differentTerritoryName: String?
    
    var chatTransportation = false
    var showChat = false
    var isCallValidateCode = false
    var isLogged = false
    var showTerritories = false
    var showCountry = false
    var permissionEnabled = true
    var isUbicacionActual = false
    var notAddressTerritory = false
    var idAddressCreated = ""
    var registerFromInvited = false

    func loadSecureCards(handler: @escaping (_ success: Bool) -> Void) {
        if let cards = self.cards, cards.count > 0 {
            handler(true)
            return
        }
        
        if let userId = PFUser.current()?.objectId {
            self.cards = self.cardManager.loadSecureCards(forUser: userId)
            handler(true)
            return
        }
        
        handler(false)
    }
    
    func getDefaultCardNew(handler: @escaping (_ card: CardObject?) -> Void) {
  
        self.getTokenizeCustomerCCs(handler:  { (success) in
            handler(self.currentCard)
        })
    }
    
    func getTokenizeCustomerCCs(handler: @escaping (_ success: Bool ) -> Void) {
        apiClient.getVGS(DoGetTokenizeCustomerCCs(
            customer_id :client_id ?? ""
        )) { response in
            switch response {
            case .success(let cards):
                if  let success = cards.success, let data = cards.data, success {
                    self.cardList = data
                    self.currentCard = nil
                    for card in data{
                        if card.is_default ?? false{
                            self.currentCard = card
                            break
                        }
                    }
                    handler(true)
                }
               
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(false)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setBaseData(_ data: [String: Any]) {
        if let name = data["name"] as? String, !name.isEmpty {
            self.name = name
            self.userData.saveProfileInfo(param: ["name": name])
        }
        if let email = data["email"] as? String, !email.isEmpty {
            self.email = email
            self.userData.saveProfileInfo(param: ["email": email])
        }
        if let phone = data["phone"] as? String, !phone.isEmpty {
            self.phone = phone
            self.userData.saveProfileInfo(param: ["phone": phone])
        }
        if let client_id = data["client_id"] as? String, !client_id.isEmpty {
            self.client_id = client_id
            self.userData.saveProfileInfo(param: ["client_id": client_id])
        }
        if let profile_id = data["profile_id"] as? String, !profile_id.isEmpty {
            self.profile_id = profile_id
            self.userData.saveProfileInfo(param: ["profile_id": profile_id])
        }
        if let avatar = data["avatar"] as? String, !avatar.isEmpty {
            self.userData.saveProfileInfo(param: ["client_image": avatar])
        }
        if let pending = data["pending_steps"] as? Int{
            self.userData.pendingSteps = pending
        }
        
        if let address = data["address_default_info"] as? [String: Any] {
            parseAddressFromDictionary(address: address)
        }

        if let territory_info = data["territory_info"] as? [String: Any] {
            let territory: Territory
            let decoder = JSONDecoder()
            do {
                let json = try JSONSerialization.data(withJSONObject: territory_info, options: [])
                territory = try decoder.decode(Territory.self, from: json)
                self.setBaseInfoTerritory(territory)
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func parseAddressFromDictionary(address: [String: Any]) {
        
        if let address_long = address["address"] as? String,
            let address_num = address["address_num"] as? String,
            let city = address["city"] as? String,
            let depto = address["depto"] as? String {
            self.fullAddress = "\(address_long), \(address_num), \(city), \(depto)"
        } else {
            self.fullAddress = nil
        }
        
        guard
            let address_type = address["address_type"] as? Int,
            let friendly_name = address["friendly_name"] as? String,
            let territory = address["territory"] as? String,
            let country = address["country"] as? String,
            let zone_mode = address["is_zone_mode"] as? Bool,
            let symbol = address["symbol"] as? String,
            let currency = address["currency"] as? String,
            let geo = address["geo"] as? [Double] else {
                return
        }
        self.address_type = address_type
        self.friendly_name = friendly_name
        self.current_territory = territory
        self.country = country
        self.is_zone_mode = zone_mode
        self.symbol = symbol
        self.currency = currency
        self.geo = "\(geo[1]),\(geo[0])"
    }
    
    func setBaseInfoTerritory(_ territoryInfo: Territory) {
        current_territory = territoryInfo._id
        country = territoryInfo.country
        is_zone_mode = territoryInfo.is_zone_mode
        symbol = territoryInfo.symbol
        currency = territoryInfo.currency
        dec_point = territoryInfo.dec_point
        thousands_sep = territoryInfo.thousands_sep

        CURRENCY_SYMBOL = territoryInfo.symbol ?? "$"
        CURRENCY = territoryInfo.currency ?? "USD"
        DECIMAL_SEP = territoryInfo.dec_point ?? "."
        THOUSAND_SEP = territoryInfo.thousands_sep ?? ","
    }
}
