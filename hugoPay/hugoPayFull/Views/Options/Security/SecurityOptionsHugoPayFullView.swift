//
//  SecurityOptionsHugoPayFullView.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class SecurityOptionsHugoPayFullView: NSObject {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var changePinOption: UIView!
    @IBOutlet weak var biometricsOption: UIView!
    
    @IBOutlet weak var pinTitle: UILabel!
    @IBOutlet weak var pinSubtitle: UILabel!
    
    @IBOutlet weak var biometricTitle: UILabel!
    @IBOutlet weak var biometricSubtitle: UILabel!
    @IBOutlet weak var biometricSwitch: UISwitch!

    @IBOutlet weak var backBtnVIew: UIView!
    
    var backFromSecurity: (()->())?
    
    var changePin: (()->())?
    var changeBiometrics: ((Bool)->())?
    
    var view: UIView!
    
    func removeViews() {
        guard let view = self.view else { return }
        
        view.removeFromSuperview()
    }
    
    func prepareViews(_ vc_view: PullUpView) {
        let nib = Bundle.main.loadNibNamed("SecurityOptionsHugoPayFullView", owner: self, options: nil)
        
        if let view = nib?.first as? UIView {
            vc_view.addSubview(view)
            let newHeight = vc_view.frame.height
            
            let tapPin = UITapGestureRecognizer(target: self, action: #selector(doChangePin))
            self.changePinOption.isUserInteractionEnabled = true
            self.changePinOption.addGestureRecognizer(tapPin)
            
            let tapClose = UITapGestureRecognizer(target: self, action: #selector(closeSecurity))
            self.backBtnVIew.isUserInteractionEnabled = true
            self.backBtnVIew.addGestureRecognizer(tapClose)
            
           
            view.frame = CGRect(x: 0, y: 0, width: vc_view.frame.width, height: newHeight)
            
            self.view = view
        }
    }

    func configureTexts(_ texts: [ConfigOptionsHPFull]?, _ active: Bool){
        if let texts = texts {
            for text in texts {
                if let option = text.header?.first(where: {$0.type == "security"}) {
                    titleLbl.text = option.text ?? ""
                 }
                if let option = text.body?.first(where: {$0.type == "sec_pin"}) {
                    pinTitle.text = option.title ?? ""
                    // pinTitle.text = option.tittle ?? ""
                    pinSubtitle.text = option.comment ?? ""
                 }
                if let option = text.body?.first(where: {$0.type == "sec_bio"}) {
                    biometricTitle.text = option.title ?? ""
                    // biometricTitle.text = option.tittle ?? ""
                    biometricSubtitle.text = option.comment ?? ""
                 }
            }
        }
        setBiometricSwitch(active)
    }
    
    func setBiometricSwitch(_ active: Bool){
        biometricSwitch.setOn(active, animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        backFromSecurity?()
    }
    
    @objc func doChangePin (){
        changePin?()
    }
    
    @objc func closeSecurity (){
        backFromSecurity?()
    }
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("on")
        }
        else{
            print("off")
        }
        self.changeBiometrics?(sender.isOn)
    }
}
