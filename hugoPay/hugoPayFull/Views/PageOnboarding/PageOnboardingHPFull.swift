//
//  PageOnboardingHPFull.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import Nuke

class PageOnboardingHPFull: UIView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var extraLbl: UILabel!

    func setImage(_ logo: String?) {
        if let url = URL(string: logo ?? "") {
            Nuke.loadImage(with: url, into: image)
        }
    }

    func setTextTitle(_ title : [OnboardingHPFullText]?) {
        let attributedString = NSMutableAttributedString(string: "")
        
        if let title = title, !title.isEmpty {
            for t in title {
                var stringFixed = ""
                
                if t.text == "hugo" {
                    stringFixed = "\(t.text ?? "")"
                } else {
                    stringFixed = "\(t.text ?? "") "
                }
                
                let attributedString2 = NSMutableAttributedString(string: stringFixed, attributes: [
                    .font: UIFont(name: getFont(t.font ?? 1), size: CGFloat(t.size ?? 10))!
                ])
                attributedString.append(attributedString2)
            }
        }
        titleLbl.attributedText = attributedString
    }

    func setTextMessage( _ message : [OnboardingHPFullText]?) {
        let attributedString = NSMutableAttributedString(string: "")
        if let message = message, !message.isEmpty{
            for m in message {
                let attributedString2 = NSMutableAttributedString(string: "\(m.text ?? "") ", attributes: [
                    .font: UIFont(name: getFont(m.font ?? 1), size: CGFloat(m.size ?? 10))!
                ])
                attributedString.append(attributedString2)
            }
        }
        messageLbl.attributedText = attributedString
    }

    func setExtra(_ extra: ExtraOnboardingHPFullText?) {
        if let extra = extra {
            extraLbl.backgroundColor = UIColor(hexString: extra.background_color?.replace(target: "#", withString: "") ?? "e9e9e9")
            extraLbl.text = extra.text ?? ""
            extraLbl.isHidden = !(extra.show ?? false)
        }
    }
    
    func getFont(_ type: Int) -> String{
        switch type {
        case 1:
            return Fonts.Black.rawValue
        case 2:
            return Fonts.Bold.rawValue
        case 3:
            return Fonts.Book.rawValue
        case 4:
            return Fonts.BookItalic.rawValue
        case 5:
            return Fonts.Medium.rawValue
        case 6:
            return Fonts.XLight.rawValue
        case 7:
            return Fonts.Book.rawValue
        case 8:
            return Fonts.Ultra.rawValue
        case 9:
            return Fonts.XLight.rawValue
        default:
            return Fonts.Book.rawValue
        }
    }
}
