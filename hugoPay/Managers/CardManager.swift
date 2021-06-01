//
//  CardManager.swift
//  Hugo
//
//  Created by Juan Jose Maceda on 3/18/17.
//  Copyright © 2017 Clever Mobile Apps. All rights reserved.
//

import Parse
import SwiftLuhn
import Foundation
import CryptoSwift
import SwiftKeychainWrapper
import HugoFun
import HugoNetworking
import HugoUI
import VGSCollectSDK

class CardManager {
    static let shared = CardManager()
    let prefix = "secureCards_"
    private let apiClient = APIClient()
    private var loadingCtx: DataSourceSignal<Bool>?
    
    func getPwd() -> String {
        let pwd = KeychainWrapper.standard.string(forKey: "cardpwd")
        if let pwd = pwd {
            return pwd
        }
        
        let new_pwd = getRandomPwd(length: 32)
        KeychainWrapper.standard.set(new_pwd, forKey: "cardpwd")
        //print(new_pwd)
        return new_pwd
    }
    
    func getSeed() -> String {
        let seed = KeychainWrapper.standard.string(forKey: "cardseed")
        if let seed = seed {
            return seed
        }
        
        let new_seed = getRandomPwd(length: 12)
        KeychainWrapper.standard.set(new_seed, forKey: "cardseed")
        //print(new_seed)
        return new_seed
    }
    
    func loadSecureCards(forUser user: String) -> [Card] {
        let pwd = self.getPwd()
        let seed = self.getSeed()
        var cardDic = [Card]()
        
        var file = self.prefix + user
        
        #if YUMMY
        
        #elseif !RELEASE
            file = "debug"
        #else
        
        #endif
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(file)
            print("PATH", path)
            if FileManager.default.fileExists(atPath: path.path) {
                do {
                    let data_encrypted = try Data(contentsOf: path)
                    let bytes = data_encrypted.bytes
                    let decrypted = try ChaCha20(key: pwd, iv: seed).decrypt(bytes)
                    let data = Data(decrypted)
                    let json_card = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                    for card in json_card {
                        let c = Card()
                        c.key = card["key"] as? String
                        c.identifier = card["identifier"] as? String
                        c.name_on_card = card["name_on_card"] as? String
                        c.card_brand_id = card["card_brand_id"] as? Int
                        c.card_month_exp = card["card_month_exp"] as? String
                        c.card_year_exp = card["card_year_exp"] as? String
                        c.card_cvc = card["card_cvc"] as? String
                        c.card_number = card["card_number"] as? String
                        c.client_id = card["client_id"] as? String
                        c.cc_start = card["cc_start"] as? String
                        c.cc_end = card["cc_end"] as? String
                        c.is_default = card["is_default"] as? Bool
                        c.color = card["color"] as? String
                        cardDic.append(c)
                    }
                    
                    return cardDic
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("ERROR CARGANDO TARJETAS")
                #if !RELEASE
                    #if !YUMMY
                        let fakeCards = self.createFakeCards()
                        self.secureCards(fakeCards, forUser: "debug")
                        return fakeCards
                    #endif
                #endif
            }
        }
        
        return [Card]()
    }
    
    func secureCards(_ cards: [Card], forUser user: String) {
        let pwd = self.getPwd()
        let seed = self.getSeed()
        var cardsArrayRepresentation = [[String: Any]]()
        
        var file = self.prefix + user
        
        #if YUMMY
        
        #elseif !RELEASE
            file = "debug"
        #else
        
        #endif
        
        if cards.count == 0 {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = dir.appendingPathComponent(file)
                if FileManager.default.fileExists(atPath: path.path) {
                    do {
                        try FileManager.default.removeItem(at: path)
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("The file for secure cards don't exist")
                }
            }
            return
        }
        
        for card in cards {
            cardsArrayRepresentation.append(card.toDictionary())
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: cardsArrayRepresentation, options: JSONSerialization.WritingOptions.prettyPrinted)
            let bytes = data.bytes
            
            let encrypted = try ChaCha20(key: pwd, iv: seed).encrypt(bytes)
            let data_encrypted = Data(encrypted)
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = dir.appendingPathComponent(file)
                do {
                    try data_encrypted.write(to: path, options: NSData.WritingOptions.atomic)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createFakeCards() -> [Card] {
        
        //tarjeta pruebas redencion de puntos
        let cardRP = Card()
        cardRP.key = "0-4550010325000037"
        cardRP.name_on_card = "AgricolaRP_0037"
        cardRP.card_brand_id = 4
        cardRP.card_month_exp = "06"
        cardRP.card_year_exp = "20"
        cardRP.card_cvc = "849"
        cardRP.card_number = "4550010325000037"
        cardRP.client_id = "XXXXXXXX"
        cardRP.cc_start = "455001"
        cardRP.cc_end = "0037"
        cardRP.is_default = false
        cardRP.color = ColorCC.Purple.rawValue

        let card0 = Card()
        card0.key = "0-4411830600050251"
        card0.name_on_card = "Agricola_0251"
        card0.card_brand_id = 4
        card0.card_month_exp = "05"
        card0.card_year_exp = "22"
        card0.card_cvc = "336"
        card0.card_number = "4411830600050251"
        card0.client_id = "XXXXXXXX"
        card0.cc_start = "441183"
        card0.cc_end = "0251"
        card0.is_default = false
        card0.color = ColorCC.Purple.rawValue
       
        
        let card1 = Card()
        card1.key = "1-9999994570392223"
        card1.name_on_card = "Serfinsa_visa 2223"
        card1.card_brand_id = 4
        card1.card_month_exp = "12"
        card1.card_year_exp = "25"
        card1.card_cvc = "123"
        card1.card_number = "9999994570392223"
        card1.client_id = "XXXXXXXX"
        card1.cc_start = "999999"
        card1.cc_end = "2223"
        card1.is_default = false
        card1.color = ColorCC.Purple.rawValue
        
        let card2 = Card()
        card2.key = "2-9999990510051036"
        card2.name_on_card = "Serfinsa_visa 9999"
        card2.card_brand_id = 4
        card2.card_month_exp = "12"
        card2.card_year_exp = "25"
        card2.card_cvc = "123"
        card2.card_number = "9999990510051036"
        card2.client_id = "XXXXXXXX"
        card2.cc_start = "999999"
        card2.cc_end = "1036"
        card2.is_default = true
        card2.color = ColorCC.Purple.rawValue
        
        let card3 = Card()
        card3.key = "3-4000000000005944"
        card3.name_on_card = "Visanet_visa 5944"
        card3.card_brand_id = 4
        card3.card_month_exp = "01"
        card3.card_year_exp = "25"
        card3.card_cvc = "4567"
        card3.card_number = "4000000000005944"
        card3.client_id = "XXXXXXXX"
        card3.cc_start = "400000"
        card3.cc_end = "5944"
        card3.is_default = false
        card3.color = ColorCC.Purple.rawValue
        
        let card4 = Card()
        card4.key = "4-4000000000000416"
        card4.name_on_card = "Visanet_Visa 4000"
        card4.card_brand_id = 4
        card4.card_month_exp = "09"
        card4.card_year_exp = "25"
        card4.card_cvc = "4567"
        card4.card_number = "4000000000000416"
        card4.client_id = "XXXXXXXX"
        card4.cc_start = "400000"
        card4.cc_end = "0416"
        card4.is_default = false
        card4.color = ColorCC.Orange.rawValue
        
        let card5 = Card()
        card5.key = "5-5300721113708330"
        card5.name_on_card = "Master_card 5300"
        card5.card_brand_id = 5
        card5.card_month_exp = "09"
        card5.card_year_exp = "25"
        card5.card_cvc = "915"
        card5.card_number = "5300721113708330"
        card5.client_id = "XXXXXXXX"
        card5.cc_start = "530072"
        card5.cc_end = "8330"
        card5.is_default = false
        card5.color = ColorCC.Yellow.rawValue
        
        let card6 = Card()
        card6.key = "6-4111111111111111"
        card6.name_on_card = "BAC_visa 4111"
        card6.card_brand_id = 4
        card6.card_month_exp = "09"
        card6.card_year_exp = "25"
        card6.card_cvc = "123"
        card6.card_number = "4111111111111111"
        card6.client_id = "XXXXXXXX"
        card6.cc_start = "411111"
        card6.cc_end = "1111"
        card6.is_default = false
        card6.color = ColorCC.Purple.rawValue
        
        let card7 = Card()
        card7.key = "7-5431111111111111"
        card7.name_on_card = "BAC_master_card 5431"
        card7.card_brand_id = 5
        card7.card_month_exp = "09"
        card7.card_year_exp = "25"
        card7.card_cvc = "123"
        card7.card_number = "5431111111111111"
        card7.client_id = "XXXXXXXX"
        card7.cc_start = "543111"
        card7.cc_end = "1111"
        card7.is_default = false
        card7.color = ColorCC.Orange.rawValue
        
        let card8 = Card()
        card8.key = "8-6011601160116611"
        card8.name_on_card = "BAC_discover 6011"
        card8.card_brand_id = 6
        card8.card_month_exp = "09"
        card8.card_year_exp = "25"
        card8.card_cvc = "123"
        card8.card_number = "6011601160116611"
        card8.client_id = "XXXXXXXX"
        card8.cc_start = "601160"
        card8.cc_end = "6611"
        card8.is_default = false
        card8.color = ColorCC.Pink.rawValue
        
        let card9 = Card()
        card9.key = "9-4111111111111111"
        card9.name_on_card = "BAC_amex 4111"
        card9.card_brand_id = 3
        card9.card_month_exp = "09"
        card9.card_year_exp = "25"
        card9.card_cvc = "123"
        card9.card_number = "4111111111111111"
        card9.client_id = "XXXXXXXX"
        card9.cc_start = "411111"
        card9.cc_end = "1111"
        card9.is_default = false
        card9.color = ColorCC.White.rawValue
        
        let card10 = Card()
        card10.key = "10-378282246310005"
        card10.name_on_card = "AMEX_sample 0005"
        card10.card_brand_id = 3
        card10.card_month_exp = "09"
        card10.card_year_exp = "25"
        card10.card_cvc = "123"
        card10.card_number = "378282246310005"
        card10.client_id = "XXXXXXXX"
        card10.cc_start = "378282"
        card10.cc_end = "0005"
        card10.is_default = false
        card10.color = ColorCC.Orange.rawValue
        
        let card11 = Card()
        card11.key = "11-4899832095020543"
        card11.name_on_card = "DaviviendaVisa 0543"
        card11.card_brand_id = 4
        card11.card_month_exp = "07"
        card11.card_year_exp = "19"
        card11.card_cvc = "071"
        card11.card_number = "4899832095020543"
        card11.client_id = "XXXXXXXX"
        card11.cc_start = "489983"
        card11.cc_end = "0543"
        card11.is_default = false
        card11.color = ColorCC.Yellow.rawValue
        
        let card12 = Card()
        card12.key = "12-4620390000019346"
        card12.name_on_card = "AgricolaVisa 9346"
        card12.card_brand_id = 4
        card12.card_month_exp = "11"
        card12.card_year_exp = "22"
        card12.card_cvc = "352"
        card12.card_number = "4620390000019346"
        card12.client_id = "XXXXXXXX"
        card12.cc_start = "462039"
        card12.cc_end = "9346"
        card12.is_default = false
        card12.color = ColorCC.Purple.rawValue
        
        let card13 = Card()
        card13.key = "13-4213380092641431"
        card13.name_on_card = "CuscatlanVisa 1431"
        card13.card_brand_id = 4
        card13.card_month_exp = "03"
        card13.card_year_exp = "27"
        card13.card_cvc = "103"
        card13.card_number = "4213380092641431"
        card13.client_id = "XXXXXXXX"
        card13.cc_start = "421338"
        card13.cc_end = "1431"
        card13.is_default = false
        card13.color = ColorCC.White.rawValue
        
        let card14 = Card()
        card14.key = "14-4815325744020585"
        card14.name_on_card = "Promerica Visa"
        card14.card_brand_id = 4
        card14.card_month_exp = "12"
        card14.card_year_exp = "23"
        card14.card_cvc = "3212"
        card14.card_number = "4815325744020585"
        card14.client_id = "XXXXXXXX"
        card14.cc_start = "481532"
        card14.cc_end = "0585"
        card14.is_default = false
        card14.color = ColorCC.Purple.rawValue
        
        let card15 = Card()
        card15.key = "15-4000000000000739"
        card15.name_on_card = "FICOHSA Visa"
        card15.card_brand_id = 4
        card15.card_month_exp = "09"
        card15.card_year_exp = "19"
        card15.card_cvc = "123"
        card15.card_number = "4000000000000739"
        card15.client_id = "XXXXXXXX"
        card15.cc_start = "400000"
        card15.cc_end = "0739"
        card15.is_default = false
        card15.color = ColorCC.Orange.rawValue
        
        let card16 = Card()
        card16.key = "16-4000000000000416"
        card16.name_on_card = "FICOHSA Visa"
        card16.card_brand_id = 4
        card16.card_month_exp = "09"
        card16.card_year_exp = "19"
        card16.card_cvc = "123"
        card16.card_number = "4000000000000416"
        card16.client_id = "XXXXXXXX"
        card16.cc_start = "400000"
        card16.cc_end = "0416"
        card16.is_default = false
        card16.color = ColorCC.Orange.rawValue
        
        let card17 = Card()
        card17.key = "17-4108240315000856"
        card17.name_on_card = "FICOHSA Visa"
        card17.card_brand_id = 4
        card17.card_month_exp = "09"
        card17.card_year_exp = "22"
        card17.card_cvc = "123"
        card17.card_number = "4108240315000856"
        card17.client_id = "XXXXXXXX"
        card17.cc_start = "410824"
        card17.cc_end = "0856"
        card17.is_default = false
        card17.color = ColorCC.White.rawValue
        
        let card18 = Card()
        card18.key = "18-5436220107447523"
        card18.name_on_card = "FICOHSA MasterCard"
        card18.card_brand_id = 5
        card18.card_month_exp = "09"
        card18.card_year_exp = "22"
        card18.card_cvc = "123"
        card18.card_number = "5436220107447523"
        card18.client_id = "XXXXXXXX"
        card18.cc_start = "543622"
        card18.cc_end = "7523"
        card18.is_default = false
        card18.color = ColorCC.White.rawValue
        
        let card19 = Card()
        card19.key = "19-5341750101241633"
        card19.name_on_card = "FICOHSA MasterCard"
        card19.card_brand_id = 5
        card19.card_month_exp = "09"
        card19.card_year_exp = "22"
        card19.card_cvc = "123"
        card19.card_number = "5341750101241633"
        card19.client_id = "XXXXXXXX"
        card19.cc_start = "534175"
        card19.cc_end = "1633"
        card19.is_default = false
        card19.color = ColorCC.White.rawValue
        
        let card20 = Card()
        card20.key = "20-4329500303405166"
        card20.name_on_card = "FICOHSA Visa"
        card20.card_brand_id = 4
        card20.card_month_exp = "10"
        card20.card_year_exp = "22"
        card20.card_cvc = "123"
        card20.card_number = "4329500303405166"
        card20.client_id = "XXXXXXXX"
        card20.cc_start = "432950"
        card20.cc_end = "5166"
        card20.is_default = false
        card20.color = ColorCC.Yellow.rawValue
        
        let card21 = Card()
        card21.key = "21-4329500303466432"
        card21.name_on_card = "FICOHSA Visa"
        card21.card_brand_id = 4
        card21.card_month_exp = "10"
        card21.card_year_exp = "22"
        card21.card_cvc = "123"
        card21.card_number = "4329500303466432"
        card21.client_id = "XXXXXXXX"
        card21.cc_start = "432950"
        card21.cc_end = "6432"
        card21.is_default = false
        card21.color = ColorCC.Yellow.rawValue
        
        let card22 = Card()
        card22.key = "22-5454800000611098"
        card22.name_on_card = "FICOHSA HN"
        card22.card_brand_id = 5
        card22.card_month_exp = "04"
        card22.card_year_exp = "22"
        card22.card_cvc = "401"
        card22.card_number = "5454800000611098"
        card22.client_id = "XXXXXXXX"
        card22.cc_start = "545480"
        card22.cc_end = "1098"
        card22.is_default = false
        card22.color = ColorCC.Yellow.rawValue
        
        //AZUL
        let card23 = Card()
        card23.key = "23-4035874000424977"
        card23.name_on_card = "AZUL 100 pesos"
        card23.card_brand_id = 4
        card23.card_month_exp = "12"
        card23.card_year_exp = "20"
        card23.card_cvc = "977"
        card23.card_number = "4035874000424977"
        card23.client_id = "XXXXXXXX"
        card23.cc_start = "403587"
        card23.cc_end = "4977"
        card23.is_default = false
        card23.color = ColorCC.Orange.rawValue
        
        let card24 = Card()
        card24.key = "24-5426064000424979"
        card24.name_on_card = "AZUL"
        card24.card_brand_id = 5
        card24.card_month_exp = "12"
        card24.card_year_exp = "24"
        card24.card_cvc = "979"
        card24.card_number = "5426064000424979"
        card24.client_id = "XXXXXXXX"
        card24.cc_start = "542606"
        card24.cc_end = "4979"
        card24.is_default = false
        card24.color = ColorCC.Orange.rawValue
        
        let card25 = Card()
        card25.key = "25-4012000033330026"
        card25.name_on_card = "AZUL"
        card25.card_brand_id = 4
        card25.card_month_exp = "12"
        card25.card_year_exp = "20"
        card25.card_cvc = "123"
        card25.card_number = "4012000033330026"
        card25.client_id = "XXXXXXXX"
        card25.cc_start = "401200"
        card25.cc_end = "0026"
        card25.is_default = false
        card25.color = ColorCC.Orange.rawValue
        
        let card26 = Card()
        card26.key = "26-5424180279791732"
        card26.name_on_card = "AZUL"
        card26.card_brand_id = 5
        card26.card_month_exp = "12"
        card26.card_year_exp = "20"
        card26.card_cvc = "732"
        card26.card_number = "5424180279791732"
        card26.client_id = "XXXXXXXX"
        card26.cc_start = "542418"
        card26.cc_end = "1732"
        card26.is_default = false
        card26.color = ColorCC.Orange.rawValue
        
        let card27 = Card()
        card27.key = "27-6011000990099818"
        card27.name_on_card = "AZUL"
        card27.card_brand_id = 5
        card27.card_month_exp = "12"
        card27.card_year_exp = "20"
        card27.card_cvc = "818"
        card27.card_number = "6011000990099818"
        card27.client_id = "XXXXXXXX"
        card27.cc_start = "601100"
        card27.cc_end = "9818"
        card27.is_default = false
        card27.color = ColorCC.Orange.rawValue
        
        let card28 = Card()
        card28.key = "28-4260550061845872"
        card28.name_on_card = "AZUL"
        card28.card_brand_id = 4
        card28.card_month_exp = "12"
        card28.card_year_exp = "20"
        card28.card_cvc = "872"
        card28.card_number = "4260550061845872"
        card28.client_id = "XXXXXXXX"
        card28.cc_start = "426055"
        card28.cc_end = "5872"
        card28.is_default = false
        card28.color = ColorCC.Orange.rawValue
        
    
        var cardeList: [Card] = [cardRP, card0,card1,card2,card3,card4,card5,card6,card7,card8,card9,card10,card11,card12,card13, card14, card15, card16, card17, card18, card19, card20, card21,card22, card23, card24, card25, card26, card27, card28]
        
        let fac_cards = [
            //visa
            ["4111111111111111", "Normal Approval CVV2Result=M"],
            ["4111111111112222", "Normal Approval CVV2Result=N"],
            ["4333333333332222", "Normal Approval CVV2Result=U"],
            ["4444444444442222", "Normal Approval CVV2Result=P"],
            ["4555555555552222", "Normal Approval CVV2Result=S"],
            ["4666666666662222", "Normal Decline OriginalResponseCode=05 CVV2Result=N"],
            ["4111111111113333", "Normal Decline OriginalResponseCode=85 AVSResult=M CVV2Result=N"],
            ["4111111111114444", "Normal Approval AVSResult=M"],
            ["4111111111115555", "Normal Approval AVSResult=A"],
            ["4111111111116666", "Normal Approval AVSResult=Z"],
            ["4111111111117777", "Normal Approval AVSResult=N"],
            ["4111111111118888", "Normal Decline OriginalResponseCode=85 AVSResult=G CVV2Result=N"],
            ["4111111111119999", "Normal Decline OriginalResponseCode=98"],
            ["4111111111110000", "Normal Decline OriginalResponseCode=91"],
            ["4222222222222222", "Normal Approval CVV2Result=M AVSResult=N"],
            //mastercard
            ["5111111111111111", "Normal Approval CVV2Result=M"],
            ["5111111111112222", "Normal Approval CVV2Result=N"],
            ["5333333333332222", "Normal Approval CVV2Result=U"],
            ["5444444444442222", "Normal Approval CVV2Result=P"],
            ["5555555555552222", "Normal Approval CVV2Result=S"],
            ["5555666666662222", "Normal Decline OriginalResponseCode=05 CVV2Result=N"],
            ["5111111111113333", "Normal Decline OriginalResponseCode=05"],
            ["5111111111114444", "Normal Approval AVSResult=Y"],
            ["5111111111115555", "Normal Approval AVSResult=A"],
            ["5111111111116666", "Normal Approval CVV2Result=M AVSResult=Z"],
            ["5111111111117777", "Normal Approval CVV2Result=M AVSResult=N"],
            ["5111111111118888", "Normal Approval CVV2Result=N AVSResult=U"],
            ["5111111111119999", "Normal Decline OriginalResponseCode=98"],
            ["5111111111110000", "Normal Decline OriginalResponseCode=91"],
            ["5222222222222222", "Normal Approval CVV2Result=N AVSResult=U"],
            //amex
            ["341111111111111", "Normal Approval CVV2Result=M"],
            ["342222222222223", "Normal Approval CVV2Result=N"],
            ["343333333333335", "Normal Approval CVV2Result=U"],
            ["344444444444447", "Normal Approval CVV2Result=P"],
            ["345555555555553", "Normal Approval CVV2Result=S"],
            ["346666666666665", "Normal Decline OriginalResponseCode=05 CVV2Result=N"],
            ["341111111111129", "Normal Decline OriginalResponseCode=05"],
            ["341111111111145", "Normal Approval AVSResult=A"],
            ["341111111111152", "Normal Approval AVSResult=Z"],
            ["341111111111160", "Normal Approval AVSResult=N"],
            ["341111111111186", "Normal Decline OriginalResponseCode=98"],
            ["341111111111194", "Normal Decline OriginalResponseCode=91"],
            ["341111111111210", "Normal Approval CVV2Result=M AVSResult=N"]
        ]
        
        var counter = 22
        for card in fac_cards {
            let card_number = card[0]
            let name = card[1]
            let cc_start = String(card_number.prefix(6))
            let cc_end = String(card_number.suffix(4))
            
            let brand_id = Int(card_number.prefix(1))
            
            var cvc = "123"
            if brand_id == 3 {
                cvc = "1234"
            }
            
            let cardItem = Card()
            cardItem.key = "\(counter)-\(card_number)"
            cardItem.name_on_card = "\(name)"
            cardItem.card_brand_id = brand_id
            cardItem.card_month_exp = "12"
            cardItem.card_year_exp = "25"
            cardItem.card_cvc = cvc
            cardItem.card_number = "\(card_number)"
            cardItem.client_id = "XXXXXXXX"
            cardItem.cc_start = cc_start
            cardItem.cc_end = cc_end
            cardItem.is_default = false
            cardItem.color = ColorCC.Purple.rawValue
            //            print("card: \(card_number)")
            //            print("cc_start: \(cc_start)")
            //            print("cc_end: \(cc_end)")
            //            print("brand_id: \(String(describing: brand_id))")
            //            print("counter: \(counter)")
            //            print("************************")
            
            cardeList.append(cardItem)
            counter = counter + 1
        }
        
        return cardeList
    }
    
    func saveCard(_ cc_start: String, _ cc_end: String, _ profile_id: String, _ territory: String, _ cc_type: String, handler: @escaping (_ result: SaveCard?) -> Void){
        var params = createNewParams()
        params["profile_id"] = profile_id
        params["cc_start"] = cc_start
        params["cc_end"] = cc_end
        params["territory"] = territory
        params["cc_type"] = cc_type
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        
        var item: SaveCard?
        
        PFCloud.callFunction(inBackground: "savecard", withParameters: params) { (result, error) in
            if error == nil, let dic = result as? [String: Any] {
                let decoder = JSONDecoder()
                do {
                    let jsonData = dic.json.data(using: .utf8)!
                    item = try decoder.decode(SaveCard.self, from: jsonData)
                } catch {
                    print(error)
                }
            }
            
            if !handleParseError(error) {
                handler(item)
            }
        }
    }
    
    func isCardAvailable(_ cc_start: String, _ cc_end: String, _ profile_id: String, _ territory: String, handler: @escaping (_ result: CardAvailable?) -> Void){
        var params = createNewParams()
        params["profile_id"] = profile_id
        params["cc_start"] = cc_start
        params["cc_end"] = cc_end
        params["territory"] = territory
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        
        var item: CardAvailable?
        
        PFCloud.callFunction(inBackground: "iscardavailable", withParameters: params) { (result, error) in
            if error == nil, let dic = result as? [String: Any] {
                let decoder = JSONDecoder()
                do {
                    let jsonData = dic.json.data(using: .utf8)!
                    item = try decoder.decode(CardAvailable.self, from: jsonData)
                } catch {
                    print(error)
                }
            }
            
            if !handleParseError(error) {
                handler(item)
            }
        }
    }
    
    
    
    func validCardsForTerritory(territoryId: String, clientId: String, cards: [[String: Any]], handler: @escaping(_ cards: [ValidCard]?) -> ()) {
        var params = createNewParams()
        params["client_id"] = clientId
        params["territory"] = territoryId
        params["list"] = cards
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        
        print(params)
        print(params)
        
        
        PFCloud.callFunction(inBackground: "checkcardlist", withParameters: params) { (response, error) in
            if let response = response {
                var cards: [ValidCard]?
                let decoder = JSONDecoder()
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    cards = try decoder.decode([ValidCard].self, from: data)
                    print(cards)
                    handler(cards)
                    return
                } catch {
                    print("error: \(error.localizedDescription)")
                }
                
                return
            }
            handler(nil)
        }
    }

   
    
    func setDefaultCard(customer_id : String,idCard : String, handler: @escaping (_ result: Bool?) -> Void) {
        
        apiClient.updateVGS(DoGetSetDefault(
            customer_id :  customer_id,
            card_id     :   idCard
        )) { response in
            switch response {
            case .success(let cards):
                if  let success = cards.success, success {
                    handler(true)
                }
            case .failure:
                 handler(false)
                
            }
        }
        
    }
    
    
    func checkValidCC(territoryId: String, handler: @escaping(_ cards: [CardValidOptions]?) -> ()) {
        var params = createNewParams()
        params["territory"] = territoryId
         params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
        
        PFCloud.callFunction(inBackground: "checkccform", withParameters: params) { (response, error) in
            if let response = response {
                var cards: [CardValidOptions]?
                let decoder = JSONDecoder()
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    cards = try decoder.decode([CardValidOptions].self, from: data)
                    handler(cards)
                    return
                } catch {
                    print("error: \(error.localizedDescription)")
                }
                
                return
            }
            handler(nil)
        }
    }
    
    /*
     Card Type    Card Number Prefix
     American Express    34, 37
     China UnionPay    62, 88
     Diners ClubCarte Blanche    300-305
     Diners Club International    300-305, 309, 36, 38-39
     Diners Club US & Canada    54, 55
     Discover Card    6011, 622126-622925, 644-649, 65
     JCB    3528-3589
     Laser    6304, 6706, 6771, 6709
     Maestro    5018, 5020, 5038, 5612, 5893, 6304, 6759, 6761, 6762, 6763, 0604, 6390
     Dankort    5019
     MasterCard    50-55
     Visa    4
     Visa Electron    4026, 417500, 4405, 4508, 4844, 4913, 4917
     */
    
    /**
     '8800000000000000': 'UNIONPAY',
     
     '4026000000000000': 'ELECTRON',
     '4175000000000000': 'ELECTRON',
     '4405000000000000': 'ELECTRON',
     '4508000000000000': 'ELECTRON',
     '4844000000000000': 'ELECTRON',
     '4913000000000000': 'ELECTRON',
     '4917000000000000': 'ELECTRON',
     
     '5019000000000000': 'DANKORT',
     
     '5018000000000000': 'MAESTRO',
     '5020000000000000': 'MAESTRO',
     '5038000000000000': 'MAESTRO',
     '5612000000000000': 'MAESTRO',
     '5893000000000000': 'MAESTRO',
     '6304000000000000': 'MAESTRO',
     '6759000000000000': 'MAESTRO',
     '6761000000000000': 'MAESTRO',
     '6762000000000000': 'MAESTRO',
     '6763000000000000': 'MAESTRO',
     '0604000000000000': 'MAESTRO',
     '6390000000000000': 'MAESTRO',
     
     '3528000000000000': 'JCB',
     '3589000000000000': 'JCB',
     '3529000000000000': 'JCB',
     
     '6360000000000000': 'INTERPAYMENT',
     
     '4916338506082832': 'VISA',
     '4556015886206505': 'VISA',
     '4539048040151731': 'VISA',
     '4024007198964305': 'VISA',
     '4716175187624512': 'VISA',
     
     '5280934283171080': 'MASTERCARD',
     '5456060454627409': 'MASTERCARD',
     '5331113404316994': 'MASTERCARD',
     '5259474113320034': 'MASTERCARD',
     '5442179619690834': 'MASTERCARD',
     
     '6011894492395579': 'DISCOVER',
     '6011388644154687': 'DISCOVER',
     '6011880085013612': 'DISCOVER',
     '6011652795433988': 'DISCOVER',
     '6011375973328347': 'DISCOVER',
     
     '345936346788903': 'AMEX',
     '377669501013152': 'AMEX',
     '373083634595479': 'AMEX',
     '370710819865268': 'AMEX',
     '371095063560404': 'AMEX'
     */
    
    func cardsAsDictionary(cards: [Card]?) -> [[String: String]]? {
        var items = [[String: String]]()
        guard let cc_cards = cards else {
            return nil
        }
        
        for cc_card in cc_cards {
            guard
                let cc_number = cc_card.card_number,
                let card_type = cc_number.customCardType(),
                let stringType = card_type.customStringValue(),
                let split = splitCardNumber(cc_number: cc_number),
                let cc_end = split["cc_end"],
                let cc_start = split["cc_start"] else {
                    return nil
            }
            
            items.append(["cc_start": cc_start,
                          "cc_end": cc_end,
                          "id": cc_card.identifier ?? "",
                          "card_type": stringType])
        }
        
        return items
    }
    

    
    
    func cardsAsSentCard(cards: [CardObject]?) -> [SentCard]? {
        var items = [SentCard]()
        guard let cc_cards = cards else {
            return nil
        }
        
        for cc_card in cc_cards {
            
            guard
                let id          = cc_card.id,
                let card_type   = cc_card.cc_brand,
                let cc_end      = cc_card.cc_end ,
                let cc_start    = cc_card.cc_start
                else{
                    return nil
            }
            items.append(SentCard(cc_start: cc_start, cc_end: cc_end, id: id, card_type: card_type))
            
        }
        return items
    }
   
    func splitCardNumber(cc_number: String) -> [String: String]? {
        guard !cc_number.isEmpty, cc_number.count == 16 || cc_number.count == 15 else {
            return nil
        }
        
        let cc_start = cc_number.prefix(6)
        let cc_end = cc_number.suffix(4)
        
        let split: [String: String] = ["cc_start": String(cc_start), "cc_end": String(cc_end)]
        return split
    }
    
}

/// Card-getting logic migrated from cclist view model to open implementation for different modules in the future.
extension CardManager {
//    func setMigrationStatus(migrated: Bool) {
//        if migrated {
//            self.getVGSCards({ [loadingCtx] _ in loadingCtx?.trigger(data: true) })
//        } else {
//            self.getEnabledCards({ [loadingCtx] _ in loadingCtx?.trigger(data: true) })
//        }
//    }
//
//    func getEnabledCards(_ block: @escaping ([EnabledCard]) -> Void) {
//        var items = [EnabledCard]()
//        UserManager.shared.loadSecureCards {
//            [getVGSCards, compareToValidate, loadingCtx] success in
//            if success {
//                guard let cards = UserManager.shared.cards else { return }
//
//                if cards.isEmpty {
//                    for card in cards {
//                        guard
//                            let cc_number = card.card_number,
//                            let split = CardManager.shared.splitCardNumber(cc_number: cc_number),
//                            let cardEnd =  split["cc_end"],
//                            let cardStart = split["cc_start"],
//                            let cardType = card.card_number?.customCardType() else {
//                            return
//                        }
//
//                        items.append(
//                            EnabledCard(
//                                cc_start: cardStart,
//                                cc_end: cardEnd,
//                                id: card.identifier,
//                                card_brand: cardType.customStringValue()
//                            )
//                        )
//                    }
//
//                    UserManager.shared.toValidateCards(oldCars: items, handler: {(validCards) in
//                        DispatchQueue.main.async {
//                            if validCards.count > 0 {
//                                compareToValidate(validCards, cards)
//                            } else {
//                                getVGSCards { _ in loadingCtx?.trigger(data: true) }
//                            }
//                        }
//                    })
//                } else {
//                    getVGSCards { _ in loadingCtx?.trigger(data: true) }
//                }
//            } else {
//                block([])
//            }
//        }
//
//    }
//
//
//    func compareToValidate(validCards: [enabledCards], cards: [Card]){
//        var vgsCards: [[String: Any]] = []
//
//        for validCard in validCards {
//            for card in cards{
//                let validId = validCard.id
//                if validId == card.identifier {
//                    guard let cardStart = card.cc_start,
//                          let cardEnd = card.cc_end,
//                          let cardType = card.card_number?.customCardType() else {
//                        return
//                    }
//
//                    let object =  [
//                        "card_name": card.name_on_card ?? "",
//                        "card_number": card.card_number ?? "",
//                        "card_expirationDate": "\(card.card_month_exp ?? "")/\(card.card_year_exp ?? "")",
//                        "card_cvc": card.card_cvc ?? "",
//                        "card_start": cardStart,
//                        "card_end": cardEnd,
//                        "card_identifier_name": "",
//                        "card_brand": cardType.customStringValue() ?? "",
//                        "card_color": card.color!,
//                        "extra_number": card.card_cvc ?? "",
//                        "customer_id": UserManager.shared.client_id ?? "",
//                        "customer_profile_id": UserManager.shared.profile_id ?? "",
//                        "app": "iOS",
//                        "build": 206,
//                        "app_id": "someAppId"
//                    ] as [String : Any]
//                    vgsCards.append(object)
//                }
//
//            }
//        }
//
//        self.sendCardsToVGS(vgsCards)
//    }
//
//
//    func sendCardsToVGS(_ parameters: [[String: Any]]) {
//        let vgsCollect = VGSCollect(id: APDLGT.VID, environment: eviromentVGS())
//
//        vgsCollect.customHeaders = [
//            "Authorization": APDLGT.VGSTKN
//        ]
//
//        var extraData = [String: Any]()
//        extraData["cards"] = parameters
//        vgsCollect.sendData(path: "/api/client-api/migration-card", extraData: extraData) { [saveMigrationStatus, loadingCtx] (response) in
//            switch response {
//            case .success(_, _, _):
//                saveMigrationStatus()
//                return
//            case .failure(let code, _, _, let error):
//                loadingCtx?.trigger(data: false)
//                switch code {
//                case 400..<499:
//                    print("Wrong Request Error: \(code)")
//                case VGSErrorType.inputDataIsNotValid.rawValue:
//                    if let error = error as? VGSError {
//                        print("Wrong Request Error a: \(error.description)")
//                    }
//                default:
//                    print("Wrong Request Error b : \(code)")
//                }
//                return
//            }
//        }
//    }
//
//    func getVGSCards(_ block: @escaping ([CardObject]) -> ()) {
//        guard let clientId = UserManager.shared.client_id else {
//                showGeneralError(ErrorCodes.PaymentTypeSelection.IncompleteParamsForValidCards)
//                return
//        }
//
//        UserManager.shared.getTokenizeCustomerCCs(handler: {
//            [filterTokenizeCardsByTerritory] (success) in
//            guard success else {
//                showGeneralError(ErrorCodes.PaymentTypeSelection.CannotLoadSecureCards)
//                return
//            }
//
//            guard let cards = CardManager.shared.cardsAsSentCard(cards:  UserManager.shared.cardList) else {
//                showGeneralError(ErrorCodes.PaymentTypeSelection.ErrorCardsToDic)
//                return
//            }
//
//            if !cards.isEmpty {
//                self.getParseCustomerCCs(territoryId: "", clientId: clientId, cards: cards) { (cards) in
//                    if let cards = cards {
//                        block(filterTokenizeCardsByTerritory(cards))
//                    } else {
//                        showGeneralError(ErrorCodes.PaymentTypeSelection.EmptyCardListFromCCBook)
//                        block([])
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    UserManager.shared.cardList = []
//                    UserManager.shared.currentCard = nil
//                }
//                block([])
//            }
//        })
//    }
//
////    func getParseCustomerCCs(territoryId: String, clientId: String, cards: [SentCard], handler: @escaping (_ cards: [resultValidCards]?) -> ()) {
////       apiClient.newSendParse(DoGetTerritoryValidation(
////           customer_id: UserManager.shared.client_id ?? "",
////           territory: UserManager.shared.current_territory ?? "",
////           service: "",
////           api: "v3",
////           list: cards
////       )){ response in
////           switch response {
////           case .success(let payservices):
////               if let success = payservices.result?.success, let cards = payservices.result?.data.cards, success {
////                   handler(cards)
////               }
////           case .failure(let error):
////               print("errorr ",error.localizedDescription)
////               print(error.localizedDescription)
////               handler(nil)
////           }
////       }
////    }
////
////    func saveMigrationStatus() {
////        apiClient.sendVGS(DoGetMigrationStatusUpdate(
////                customer_id: UserManager.shared.client_id ?? "test",
////                customer_profile_id: UserManager.shared.profile_id ?? "test"
////        )) { [getVGSCards, loadingCtx] response in
////            switch response {
////            case .success(let cards):
////                if  let success = cards.success, success {
////                    getVGSCards({ _ in loadingCtx?.trigger(data: true) })
////                }
////            case .failure(let error):
////                showGeneralErrorCustom(ErrorCodes.HugoPay.PayServicesProviders.GetPayProvidersFail)
////                print(error.localizedDescription)
////            }
////        }
////    }
////
////    @discardableResult private func filterTokenizeCardsByTerritory(valid_cards: [resultValidCards]) -> [CardObject] {
////        guard let tokenizeCustomerCCs = UserManager.shared.cardList else { return [] }
////
////        var cards : [CardObject] = []
////        for tokenizeCard in tokenizeCustomerCCs {
////            var current_card = tokenizeCard
////            for card in valid_cards {
////                if current_card.cc_start == card.cc_start && current_card.cc_end == card.cc_end {
////                    current_card.enabled = card.enabled
////                    if current_card.is_default ?? false{
////                        UserManager.shared.currentCard = current_card
////                    }
////                    cards.append(current_card)
////                    break
////                }
////            }
////        }
////
////        UserManager.shared.cardList = cards
////
////        return cards
////    }
//
//    func secureCards() {
//        if let cards = UserManager.shared.cards {
//            if let userId = PFUser.current()?.objectId {
//                CardManager.shared.secureCards(cards, forUser: userId)
//            }
//        }
//    }
//
//    func setDefaultCardVGS(customer_id : String, card : CardObject) {
//        apiClient.updateVGS(DoGetSetDefault(
//            customer_id :  customer_id,
//            card_id     :   card.id ?? ""
//        )) { [loadingCtx] response in
//            switch response {
//            case .success(let cards):
//                if  let success = cards.success, success {
//                    self.getVGSCards { _ in loadingCtx?.trigger(data: true) }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    showGeneralErrorCustom(ErrorCodes.HugoPay.PayServicesProviders.GetPayProvidersFail)
//                }
//                print(error.localizedDescription)
//            }
//        }
//    }
}

extension CardManager: FundingInstrumentDelegateProvider,
                       FundingInstrumentDelegate {
    var fundingInstrumentDelegate: FundingInstrumentDelegate {
        self
    }
    
    func loadInstruments(_ block: @escaping (Bool) -> Void) {
//        startMigrationIfNeeded().subscribe { (success) in
//            block(success ?? false)
//        }
        block(true)
    }
    
    func getFundingInstruments() -> [FundingInstrument] {
        var selectedColor: String = ColorScheme.primary
        return UserManager.shared.cardList?
            .map { (card) -> FundingInstrument in
                let cardSelector = CreditCard()
                if let color = card.card_color {
                    selectedColor = color
                }
                _ = cardSelector.defaultIcon(color: selectedColor)
                
                return FundingInstrument(
                    name: card.cc_end ?? "****",
                    type: FundingInstrument.InstrumentType.card(
                        FundingInstrument.InstrumentCardSubtype.from(
                            card.cc_brand
                        )
                    ),
                    token: card.id ?? card.card_identifier_name ?? "",
                    thumbnail: cardSelector.cardImageWithColor(
                        with: SwiftLuhn.CardType.init(string: card.cc_brand ?? "Visa"),
                        color: ColorCC.White.rawValue
                    ),
                    color: ColorScheme.white.value
                )
            } ?? []
    }
    
    func startFlow(for type: FundingInstrumentFlowType) {
        switch type {
        case .add:
            break
//            if let vc = R.storyboard.creditCard.ccRegistrationViewController() {
//                vc.modalPresentationStyle = .fullScreen
//                UIApplication
//                    .topViewController()?
//                    .present(vc, animated: true, completion: nil)
//            }
        }
    }
}
