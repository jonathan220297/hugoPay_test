//
//  UIColor+HugoPayFull.swift
//  Hugo
//
//  Created by Carlos Landaverde on 3/8/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let hpfPurpleMainTitle = UIColor(displayP3Red: 46.0/255.0, green: 16.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    static let hpfPurpleMainButton = UIColor(displayP3Red: 89.0/255.0, green: 26.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    
}

extension UIColor {
    
    static let grayUltraLight = UIColor(displayP3Red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    
    static let gray244HugoPay = UIColor(displayP3Red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    
    static let purpleLight = UIColor(red: 128.0/255.0, green: 107.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    
    static let purpleTitle = UIColor(red: 55.0/255.0, green: 24.0/255.0, blue: 101.0/255.0, alpha: 1.0)
    
    static let purple2TitleHugoPay = UIColor(red: 42.0/255.0, green: 12.0/255.0, blue: 88.0/255.0, alpha: 1.0)
    
    static let purpleOptionTitle = UIColor(red: 60.0/255.0, green: 27.0/255.0, blue: 93.0/255.0, alpha: 1.0)
    
    static let purpleTitleLight = UIColor(red: 226.0/255.0, green: 221.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    
    static let purpleTitleSoftHugoPay = UIColor(red: 154.0/255.0, green: 113.0/255.0, blue: 195.0/255.0, alpha: 1.0)
    
    static let aquaHugoPay = UIColor(red: 63.0/255.0, green: 225.0/255.0, blue: 199.0/255.0, alpha: 1.0)
    
    static let redAlertHugoPay = UIColor(red: 253.0/255.0, green: 235.0/255.0, blue: 229.0/255.0, alpha: 1.0)
    
    static let orangeAlertHugoPay = UIColor(red: 242.0/255.0, green: 131.0/255.0, blue: 93.0/255.0, alpha: 1.0)
    
    static let purpleSoftHugoPay = UIColor(red: 210.0/255.0, green: 182.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    
    static let gridGrayHugoPay = UIColor(red: 232.0/255.0, green: 237.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    
    static let gridTextGrayHugoPay = UIColor(red: 156.0/255.0, green: 175.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    
    static let mugGrayTextHugoPay = UIColor(red: 128.0/255.0, green: 120.0/255.0, blue: 140.0/255.0, alpha: 1.0)
    
    static let touchingGrayHugoPay = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    
    static let touchingPurpleHugoPay = UIColor(red: 128.0/255.0, green: 111.0/255.0, blue: 181.0/255.0, alpha: 1.0)
    
    static func getCardTextColor(_ color: String) -> UIColor {
            switch color {
            case ColorCC.Purple.rawValue:
                return UIColor(hex: ColorsCCLetter.ccPurple.rawValue)
            case ColorCC.Pink.rawValue:
                return UIColor(hex: ColorsCCLetter.ccPink.rawValue)
            case ColorCC.White.rawValue:
                return UIColor(hex: ColorsCCLetter.ccWhite.rawValue)
            case ColorCC.Yellow.rawValue:
                return UIColor(hex: ColorsCCLetter.ccWhite.rawValue)
            case ColorCC.Orange.rawValue:
                return UIColor(hex: ColorsCCLetter.ccOrange.rawValue)
            default:
                return UIColor(hex: ColorsCCLetter.ccPurple.rawValue)
            }
    }
    
    // MARK: - Hex to RGB
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let divideBy: CGFloat = 255.0
        var rgb: UInt64 = 0
        let scanner = Scanner(string: hex)
        scanner.scanHexInt64(&rgb)
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / divideBy,
                  green: CGFloat((rgb & 0xFF00) >> 8) / divideBy,
                  blue: CGFloat((rgb & 0xFF)) / 255.0,
                  alpha: alpha)
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    convenience init?(hexString: String) {
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(hex: hex)
    }
    var hexString: String {
        //Retorna el valor hexadecimal de un color incluyendo la opacidad sin el signo # por ejemplo: FFF
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha

        var color = String(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )

        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a * 255)))
        }

        return color
    }
}
