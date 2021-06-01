//
//  Common.swift
//  HugoPay
//
//  Created by Jonathan  Rodriguez on 28/5/21.
//

import Foundation
import Malert
import SimpleAlert
import Parse

var errorMalert: Malert?

func showGeneralError(_ code: String?) {
    let message = code != nil ? "\(Strings.GeneralErrorMsg)" + " " + "Code".localizedString + ": (\(code ?? ""))" : "\(Strings.GeneralErrorMsg)"
    UIApplication.topViewController()?.simpleAlert(title: Strings.GeneralErrorTitle, message: message)
}

func showErrorCustom(_ title: String, _ message: String) {
     let confirmAlert = GeneralErrorAlert.instantiateFromNib()
    confirmAlert.close = hideErrorAlert
    confirmAlert.populateError(title, message)
    errorMalert = Malert(customView: confirmAlert, tapToDismiss: false)
    
    UIApplication.topViewController()?.present(errorMalert!, animated: true, completion: nil)
}

func showGeneralErrorCustom(_ code: String?){
    let confirmAlert = GeneralErrorAlert.instantiateFromNib()
    confirmAlert.close = hideErrorAlert
    confirmAlert.populateGeneralError(code ?? "")
    errorMalert = Malert(customView: confirmAlert, tapToDismiss: false)
    
    UIApplication.topViewController()?.present(errorMalert!, animated: true, completion: nil)
}

func hideErrorAlert(){
    errorMalert!.dismiss(animated: true, completion: nil)
}

extension Dictionary {
    mutating func update(other: Dictionary?) {
        guard let otherDict = other else { return }
        for (key,value) in otherDict {
            self.updateValue(value, forKey:key)
        }
    }
    
    var json: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    func convertToJson() -> String {
        return json
    }
}

func handleParseError(_ error: Error?) -> Bool {
    if let error = error {
        let err = error as NSError
        switch err.code {
        case PFErrorCode.errorInvalidSessionToken.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: ErrorNotifications.INVALID_SESSION_TOKEN), object: nil)
            return true
        default:
            print(err.description)
            return false
        }
    } else {
        return false
    }
}

func getMyCustomString(_ key: String) -> String {
    return Bundle.main.object(forInfoDictionaryKey: key) as! String
}

func hugoVersion() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    let build = dictionary["CFBundleVersion"] as! String
    return "v\(version).\(build)"
}

func buildVersion() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let build = dictionary["CFBundleVersion"] as! String
    return build
}

func getRandomPwd(length: Int = 10) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

struct SaveCard: Codable {
    var id: String?
    var disable: Bool?
    var message: String?
}

struct CardAvailable: Codable {
    var available: Bool?
    var message: String?
}

struct ValidCard: Codable {
    var cc_start: String?
    var cc_end: String?
    var id: String?
    var enabled: Bool?
    var generated_id: Bool?
    var card_type: String?
    var point_redemptions: Bool?
    var type: String?
    
    public func toDictionary() -> [String: Any] {
        return ["cc_start": cc_start!, "cc_end": cc_end!, "id": id!, "enabled": enabled!]
    }
}
struct SentCard: Encodable {
    internal init(cc_start: String?, cc_end: String?, id: String?, card_type: String?) {
        self.cc_start = cc_start
        self.cc_end = cc_end
        self.id = id
        self.card_type = card_type
    }
    
    var cc_start: String?
    var cc_end: String?
    var id: String?
    var card_type: String?
}
struct EnabledCard: Encodable {
    internal init(cc_start: String?, cc_end: String?, id: String?, card_brand: String?) {
        self.cc_start = cc_start
        self.cc_end = cc_end
        self.id = id
        self.card_brand = card_brand
    }
    
    var cc_start: String?
    var cc_end: String?
    var id: String?
    var card_brand: String?
}

struct PointsCards: Encodable {
    internal init(cc_start: String?, cc_end: String?, id: String?, card_type: String?, type: String?) {
        self.cc_start = cc_start
        self.cc_end = cc_end
        self.id = id
        //self.year = year
        //self.month = month
        self.card_type = card_type
        //self.expiration_date = expiration_date
        self.type = type
        //self.number = number
    }
    
    var cc_start: String?
    var cc_end: String?
    var id: String?
    var year: String?
    var month: String?
    var card_type: String?
    var expiration_date: String?
    var type: String?
    var number: String?
    
}

struct ValidCardList: Encodable {
    var cc_start: String?
    var cc_end: String?
    var id: String?
    var enabled: Bool?
    var card_type: String?

}
struct CardValidOptions: Codable {
    var cc_type: String
    var cvv_length: Int
    var cc_length: Int
}

extension UIApplication {
    class func rootController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        return controller
    }
    
    class func getTopMostController() -> UIViewController? {
        var topController = UIWindow().rootViewController
        
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        
        return topController
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    class func topControllerName() -> String? {
        let controller = self.topViewController()
        
        if controller == nil {
            return "empty name, error"
        }
        
        return NSStringFromClass(controller!.classForCoder)
    }
}

extension UIViewController {
    func simpleAlert(title: String?, message: String?) {
        let alert = AlertController(title: title, message: message, style: .alert)
        alert.addAction(AlertAction(title: AlertString.OK, style: .ok, shouldDismisses: true, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
     func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func convertImageToBase64() -> String {
        let imageData = resizeImage(image: self, targetSize: CGSize(width: 320, height: 320)).jpegData(compressionQuality: 0.75)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithCarriageReturn)
    }
    
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
