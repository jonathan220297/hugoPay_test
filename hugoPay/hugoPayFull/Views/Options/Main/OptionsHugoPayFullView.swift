//
//  OptionsHugoPayFullView.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import Nuke

class OptionsHugoPayFullView: NSObject {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addCCOption: UIView!
    @IBOutlet weak var securityOption: UIView!
    @IBOutlet weak var helpOption: UIView!
    
    @IBOutlet weak var ccImage: UIImageView!
    @IBOutlet weak var ccTitle: UILabel!
    @IBOutlet weak var ccSubtitle: UILabel!
    
    @IBOutlet weak var securityImage: UIImageView!
    @IBOutlet weak var securityTitle: UILabel!
    @IBOutlet weak var securitySubtitle: UILabel!
    
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var helpTitle: UILabel!
    @IBOutlet weak var helpSubtitle: UILabel!
    
    var view: UIView!
    
    var goCC : (()->())?
    var goSecurity : (()->())?
    var goHelp : (()->())?
    
    func removeViews() {
        guard let view = self.view else { return }
        
        view.removeFromSuperview()
    }
    
    func prepareViews(_ vc_view: PullUpView) {
        let nib = Bundle.main.loadNibNamed("OptionsHugoPayFullView", owner: self, options: nil)
        
        if let view = nib?.first as? UIView {
            vc_view.addSubview(view)
            let newHeight = vc_view.frame.height            
            
            let tapCC = UITapGestureRecognizer(target: self, action: #selector(openCC))
            self.addCCOption.addGestureRecognizer(tapCC)
            
            let tapSecurity = UITapGestureRecognizer(target: self, action: #selector(openSecurity))
            self.securityOption.addGestureRecognizer(tapSecurity)
            
            let tapHelp = UITapGestureRecognizer(target: self, action: #selector(openHelp))
            self.helpOption.addGestureRecognizer(tapHelp)
            
            view.frame = CGRect(x: 0, y: 0, width: vc_view.frame.width, height: newHeight)
            
            self.view = view
        }
    }
    
    func configureTexts(_ texts: [ConfigOptionsHPFull]?){
        if let texts = texts {
            for text in texts {
                if let option = text.header?.first(where: {$0.type == "conf_header"}) {
                    titleLbl.text = option.text ?? ""
                 }
                if let option = text.body?.first(where: {$0.type == "conf_tarj"}) {
                    ccTitle.text = option.title ?? ""
                    ccSubtitle.text = option.comment ?? ""
                    if let url = URL(string: option.image ?? ""){
                        Nuke.loadImage(with: url, into: ccImage)
                    }
                 }
                if let option = text.body?.first(where: {$0.type == "conf_sec"}) {
                    securityTitle.text = option.title ?? ""
                    securitySubtitle.text = option.comment ?? ""
                    if let url = URL(string: option.image ?? ""){
                        Nuke.loadImage(with: url, into: securityImage)
                    }
                 }
                if let option = text.body?.first(where: {$0.type == "conf_help"}) {
                    helpTitle.text = option.title ?? ""
                    helpSubtitle.text = option.comment ?? ""
                    if let url = URL(string: option.image ?? ""){
                        Nuke.loadImage(with: url, into: helpImage)
                    }
                 }
            }
        }
    }
    
    @objc func openCC(){
        goCC?()
    }
    @objc func openSecurity(){
        goSecurity?()
    }
    @objc func openHelp(){
        goHelp?()
    }
}
