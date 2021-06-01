//
//  CardSelector.swift
//  Hugo
//
//  Created by Developer on 7/11/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import SwiftLuhn
import Foundation

public class CreditCard {
    class func getCharCVVCountByType(with cardType:String?) -> Int {
           var maxim = 3

           guard let type = cardType?.lowercased() else {
               return maxim
           }

           switch type {
           
           case "amex", "american express":
               maxim = 4
         
           default:
               maxim = 3
           }

           return maxim
       }
    class func cardImage(with cardType: SwiftLuhn.CardType?) -> UIImage {
        var icon = #imageLiteral(resourceName: "ic_cc_color")
        
        guard let type = cardType else {
            return icon
        }
        
        switch type {
        case .visa:
            icon = #imageLiteral(resourceName: "ic_visa-curved")
        case .mastercard, .maestro:
            icon = #imageLiteral(resourceName: "ic_mastercard-curved")
        case .amex:
            icon = #imageLiteral(resourceName: "ic_amex")
        case .discover:
            icon = #imageLiteral(resourceName: "ic_discover")
        default:
            icon = #imageLiteral(resourceName: "ic_cc_color")
        }
        
        return icon
    }
    class func cardImageByString(with tipo: String?) -> UIImage {
        var icon = #imageLiteral(resourceName: "ic_cc_color")
        
        guard let type = tipo?.lowercased() else {
            return icon
        }
        
        switch type {
        case "visa":
            icon = #imageLiteral(resourceName: "ic_visa-curved")
        case "mastercard", "maestro":
            icon = #imageLiteral(resourceName: "ic_mastercard-curved")
        case "amex", "american express":
            icon = #imageLiteral(resourceName: "ic_amex")
        case "discover":
            icon = #imageLiteral(resourceName: "ic_discover")
        default:
            icon = #imageLiteral(resourceName: "ic_cc_color")
        }
        
        return icon
    }

    class func cardImagePayService(with cardType: SwiftLuhn.CardType?) -> UIImage {
        var icon = #imageLiteral(resourceName: "ic_cc_color")

        guard let type = cardType else {
            return icon
        }

        switch type {
        case .visa:
            icon = #imageLiteral(resourceName: "visa_logo")
        case .mastercard:
            icon = #imageLiteral(resourceName: "mastercard_logo")
        case .maestro:
            icon = #imageLiteral(resourceName: "maestro_logo")
        case .amex:
            icon = #imageLiteral(resourceName: "amex_logo")
        case .discover:
            icon = #imageLiteral(resourceName: "ic_discover")
        default:
            icon = #imageLiteral(resourceName: "ic_cc_color")
        }

        return icon
    }
    class func cardImagePayServiceByString(with cardType:String?) -> UIImage {
        var icon = #imageLiteral(resourceName: "ic_cc_color")

        guard let type = cardType?.lowercased() else {
            return icon
        }

        switch type {
        case "visa":
            icon = #imageLiteral(resourceName: "visa_white.pdf")
        case "mastercard":
            icon = #imageLiteral(resourceName: "mastercard_shipment")
        case "maestro":
            icon = #imageLiteral(resourceName: "mastercard_shipment")
        case "amex", "american express":
            icon = #imageLiteral(resourceName: "amex_shipment")
        case "discover":
            icon = #imageLiteral(resourceName: "ic_discover")
        default:
            icon = #imageLiteral(resourceName: "ic_cc_color")
        }

        return icon
    }
    
    class func cardImageNew(with cardType: SwiftLuhn.CardType?) -> UIImage {
        var icon = #imageLiteral(resourceName: "ic_cc_color")

        guard let type = cardType else {
            return icon
        }

        switch type {
        case .visa:
            icon = #imageLiteral(resourceName: "visa_shipment")
        case .mastercard, .maestro:
            icon = #imageLiteral(resourceName: "mastercard_shipment")
        case .amex:
            icon = #imageLiteral(resourceName: "amex_shipment")
        case .discover:
            icon = #imageLiteral(resourceName: "ic_discover")
        default:
            icon = #imageLiteral(resourceName: "ic_cc_color")
        }

        return icon
    }
    
    
    
    func cardImageWithColor(with cardType: SwiftLuhn.CardType?, color: String?) -> UIImage {
        var icon = #imageLiteral(resourceName: "ic_cc_color")
        
        guard let type = cardType else {
            return icon
        }
        
        switch type {
        case .visa:
            icon = visaIcon(color: color)
        case .mastercard, .maestro:
            icon = masterCardIcon(color: color)
        case .amex:
            icon = amexIcon(color: color)
        case .discover:
            icon = #imageLiteral(resourceName: "ic_discover")
        default:
            icon = #imageLiteral(resourceName: "ic_cc_color")
        }
        
        return icon
    }
    
    func cardBrand(with cardType: String?, color: String?) -> UIImage {
        var icon = #imageLiteral(resourceName: "ic_cc_color")
        
        guard let type = cardType else {
            return icon
        }
        
        switch type {
        case "Visa":
            icon = visaIcon(color: color)
        case "Mastercard", "Maestro":
            icon = masterCardIcon(color: color)
        case "Amex", "American Express":
            icon = amexIcon(color: color)
        case "Discover":
            icon = #imageLiteral(resourceName: "ic_discover")
        default:
            icon = #imageLiteral(resourceName: "ic_cc_color")
        }
        
        return icon
    }
    
    func defaultIcon(color: String?) -> UIImage {
        switch color {
        case ColorCC.Purple.rawValue:
            return  #imageLiteral(resourceName: "cc_purple")
        case ColorCC.Pink.rawValue:
            return  #imageLiteral(resourceName: "cc_pink")
        case ColorCC.White.rawValue:
            return  #imageLiteral(resourceName: "cc_white")
        case ColorCC.Yellow.rawValue:
            return  #imageLiteral(resourceName: "cc_yellow")
        case ColorCC.Orange.rawValue:
            return  #imageLiteral(resourceName: "cc_orange")
        default:
            return  #imageLiteral(resourceName: "cc_purple")
        }
    }
    
    func defaultVerticalIcon(color: String?) -> UIImage {
        switch color {
        case ColorCC.Purple.rawValue:
            return UIImage(named: "card_vertical_purple_hp")!
        case ColorCC.Pink.rawValue:
            return UIImage(named: "card_vertical_pink_hp")!
        case ColorCC.White.rawValue:
            return UIImage(named: "card_vertical_white_hp")!
        case ColorCC.Yellow.rawValue:
            return UIImage(named: "card_vertical_yellow_hp")!
        case ColorCC.Orange.rawValue:
            return UIImage(named: "card_vertical_orange_hp")!
        default:
            return UIImage(named: "card_vertical_purple_hp")!
        }
    }
    
    func visaIcon(color: String?) -> UIImage {
        switch color {
        case ColorCC.Purple.rawValue:
            return  #imageLiteral(resourceName: "visa_purple")
        case ColorCC.Pink.rawValue:
            return  #imageLiteral(resourceName: "visa_pink")
        case ColorCC.White.rawValue:
            return  #imageLiteral(resourceName: "visa_white")
        case ColorCC.Yellow.rawValue:
            return  #imageLiteral(resourceName: "visa_yellow")
        case ColorCC.Orange.rawValue:
            return  #imageLiteral(resourceName: "visa_orange")
        default:
            return  #imageLiteral(resourceName: "visa_purple")
        }
    }
    
    func masterCardIcon(color: String?) -> UIImage {
        switch color {
        case ColorCC.Purple.rawValue:
            return  #imageLiteral(resourceName: "mastercard_purple")
        case ColorCC.Pink.rawValue:
            return  #imageLiteral(resourceName: "mastercard_pink")
        case ColorCC.White.rawValue:
            return  #imageLiteral(resourceName: "mastercard_white")
        case ColorCC.Yellow.rawValue:
            return  #imageLiteral(resourceName: "mastercard_yellow")
        case ColorCC.Orange.rawValue:
            return  #imageLiteral(resourceName: "mastercard_orange")
        default:
            return  #imageLiteral(resourceName: "mastercard_purple")
        }
    }
    
    func amexIcon(color: String?) -> UIImage {
        switch color {
        case ColorCC.Purple.rawValue:
            return  #imageLiteral(resourceName: "amex_purple")
        case ColorCC.Pink.rawValue:
            return  #imageLiteral(resourceName: "amex_pink")
        case ColorCC.White.rawValue:
            return  #imageLiteral(resourceName: "amex_white")
        case ColorCC.Yellow.rawValue:
            return  #imageLiteral(resourceName: "amex_yellow")
        case ColorCC.Orange.rawValue:
            return  #imageLiteral(resourceName: "amex_orange")
        default:
            return  #imageLiteral(resourceName: "amex_purple")
        }
    }
    
}

public extension SwiftLuhn.CardType {
    func customStringValue() -> String? {
        switch self {
        case .visa:
            return "Visa"
        case .mastercard:
            return "Mastercard"
        case .maestro:
            return "Maestro"
        case .amex:
            return "Amex"
        case .dinersClub:
            return "DinersClub"
        case .discover:
            return "Discover"
        default:
            #if YUMMY
                return nil
            #elseif !RELEASE
                return "Visa"
            #else
                return nil
            #endif
        }
    }
}

public extension String {
    func customCardType() -> SwiftLuhn.CardType? {
        let card = self.replace(target: " ", withString: "")
        
        #if YUMMY
            return card.cardType()
        #elseif !RELEASE
            return card.cardType() ?? SwiftLuhn.CardType.visa
        #else
            return card.cardType()
        #endif
    }
}
