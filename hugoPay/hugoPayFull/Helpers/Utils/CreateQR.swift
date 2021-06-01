//
//  CreateQR.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/14/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import UIKit

public func generateQRCode(_ jsonDict : [String: Any]) -> UIImage{
    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted]) else {
        return UIImage()
    }
    let filter = CIFilter(name: "CIQRCodeGenerator")
    filter?.setValue(jsonData, forKey: "InputMessage")
    let qrTransform = CGAffineTransform(scaleX: 1, y: 1)
    let qrImage = filter?.outputImage?.transformed(by: qrTransform)
    let colorParameters = [
           "inputColor0": CIColor(color: UIColor.black), // Foreground
           "inputColor1": CIColor(color: UIColor.clear) // Background
       ]
    
     let colored = qrImage?.applyingFilter("CIFalseColor", parameters: colorParameters)
//    let colored = qrImage.applyingFilter("CIFalseColor", parameters: colorParameters)

    return UIImage(ciImage: colored!)
}


public func generateQRCode(_ jsonData : Data) -> UIImage {

    let filter = CIFilter(name: "CIQRCodeGenerator")
    filter?.setValue(jsonData, forKey: "InputMessage")
    let qrTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)
    let qrImage = filter?.outputImage?.transformed(by: qrTransform)
    let colorParameters = [
           "inputColor0": CIColor(color: UIColor.black), // Foreground
           "inputColor1": CIColor(color: UIColor.clear) // Background
       ]
    
     let colored = qrImage?.applyingFilter("CIFalseColor", parameters: colorParameters)

    return UIImage(ciImage: colored!)
}


public func generatePurpleQRCode(_ jsonData : Data) -> UIImage{
//    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted]) else {
//        return UIImage()
//    }
    let filter = CIFilter(name: "CIQRCodeGenerator")
    filter?.setValue(jsonData, forKey: "InputMessage")
    let qrTransform = CGAffineTransform(scaleX: 5, y: 5)
    let qrImage = filter?.outputImage?.transformed(by: qrTransform)
    let colorParameters = [
        "inputColor0": CIColor(color: UIColor.init(hexString: "3c1b5d")!), // Foreground
        "inputColor1": CIColor(color: UIColor.clear) // Background
       ]
    
     let colored = qrImage?.applyingFilter("CIFalseColor", parameters: colorParameters)
//    let colored = qrImage.applyingFilter("CIFalseColor", parameters: colorParameters)

    return UIImage(ciImage: colored!)
}
