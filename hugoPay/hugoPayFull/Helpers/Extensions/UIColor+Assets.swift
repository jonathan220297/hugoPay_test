//
//  UIColor+Assets.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/24/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

// MARK: - hugo colors from Colors.xcassets

extension UIColor {

    static let lightGray1 = UIColor.fromAsset(named: "LightGray1")
    
    static let lightGray2 = UIColor.fromAsset(named: "LightGray2")
    
    static let blackAlert = UIColor.fromAsset(named: "BlackAlert")
    
    static let blackShadow = UIColor.fromAsset(named: "BlackShadow")
    
    static let blueGrayShadow = UIColor.fromAsset(named: "BlueGrayShadow")
    
    static let blueMagentaishGray = UIColor.fromAsset(named: "BlueMagentaishGray")
    
    static let brightPurple = UIColor.fromAsset(named: "BrightPurple")
    
    static let burntSienna = UIColor.fromAsset(named: "BurntSienna")
    
    static let darkPurple = UIColor.fromAsset(named: "DarkPurple")
    
    static let deepPurple = UIColor.fromAsset(named: "DeepPurple")
    
    static let filterOptionUnSelected = UIColor.fromAsset(named: "FilterOptionUnSelected")
    
    static let graySuit = UIColor.fromAsset(named: "GraySuit")
    
    static let greenMint = UIColor.fromAsset(named: "GreenMint")
    
    static let lightGrayishPurple1 = UIColor.fromAsset(named: "LightGrayishPurple1")
    
    static let lightGrayishPurple2 = UIColor.fromAsset(named: "LightGrayishPurple2")
    
    static let lightGrayishPurple2Shadow = UIColor.fromAsset(named: "LightGrayishPurple2Shadow")
    
    static let lightGrayShadow = UIColor.fromAsset(named: "LightGrayShadow")
    
    static let mobster = UIColor.fromAsset(named: "Mobster")
    
    static let paleLilac = UIColor.fromAsset(named: "PaleLilac")
    
    static let paleOrange = UIColor.fromAsset(named: "PaleOrange")
    
    static let palePurple = UIColor.fromAsset(named: "PalePurple")
    
    static let purpleCake = UIColor.fromAsset(named: "PurpleCake")
    
    static let strongPurple1 = UIColor.fromAsset(named: "StrongPurple1")
    
    static let strongPurple2 = UIColor.fromAsset(named: "StrongPurple2")
    
    static let whiteEdit = UIColor.fromAsset(named: "WhiteEdit")

    static let transactionFilterLine = UIColor.fromAsset(named: "TransactionFilterLine")

    static let transactionFilterSelected = UIColor.fromAsset(named: "TransactionFilterSelected")

    static let headerPurple = UIColor.fromAsset(named: "headerPurple")
    
    static let headlineGray = UIColor.fromAsset(named: "headlineGray")
    
    static let strokeWhite = UIColor.fromAsset(named: "strokeWhite")
    
    static let textfieldPlaceholder = UIColor.fromAsset(named: "textfieldPlaceholder")
    
    static let newPurple = UIColor.fromAsset(named: "newPurple")
    
    static let statusYellow = UIColor.fromAsset(named: "statusYellow")
}

fileprivate extension UIColor {
    static func fromAsset(named name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("Color \(name) is not defined in a color asset.")
        }
        return color
    }
}
