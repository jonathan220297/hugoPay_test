//
//  ResetPinOptionsHugoPayFullView.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/23/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class ResetPinOptionsHugoPayFullView: NSObject {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendEmailOption: UIView!
    @IBOutlet weak var sendSmsOption: UIView!
    
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailSubtitle: UILabel!
    
    @IBOutlet weak var smsImage: UIImageView!
    @IBOutlet weak var smsSubtitle: UILabel!

    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupSubTitleEmail: UILabel!
    @IBOutlet weak var popupSubTitleSMS: UILabel!
    @IBOutlet weak var popupSubtitle: UILabel!
    
    
    var view: UIView!
    
    var goSendEmail : (()->())?
    var goSendSms : (()->())?
    
    func removeViews() {
        guard let view = self.view else { return }
        view.removeFromSuperview()
    }
    
    func prepareViews(_ vc_view: PullUpView) {
        let nib = Bundle.main.loadNibNamed("ResetPinOptionsHugoPayFullView", owner: self, options: nil)
        popupTitle.text = "hp_title_recovery_method".localizedString
        popupSubtitle.text = "hp_full_reset_pin_options_subtitle".localizedString
        
        if let view = nib?.first as? UIView {
            vc_view.addSubview(view)
            var newHeight = vc_view.frame.height
            var safeAreaInsetsBottom: CGFloat = 0.0
            
            
            let tapEmail = UITapGestureRecognizer(target: self, action: #selector(sendEmail))
            self.sendEmailOption.addGestureRecognizer(tapEmail)
            
            let tapSms = UITapGestureRecognizer(target: self, action: #selector(sendSms))
            self.sendSmsOption.addGestureRecognizer(tapSms)
            
            if #available(iOS 11.0, *) {
                safeAreaInsetsBottom = vc_view.safeAreaInsets.bottom
                newHeight = vc_view.frame.height + vc_view.safeAreaInsets.bottom
            }
            
            view.frame = CGRect(x: 0, y: vc_view.insets.top - safeAreaInsetsBottom, width: vc_view.frame.width, height: newHeight)
            
            self.view = view
        }
    }
    
    func configureTexts(userEmail: String?, userNumber: String?) {
        if let userEmail = userEmail {
            emailSubtitle.text = userEmail
        }
        if let userNumber = userNumber {
            smsSubtitle.text = userNumber
        }
    }
    
    @objc func sendEmail(){
        goSendEmail?()
    }
    @objc func sendSms(){
        goSendSms?()
    }
}
