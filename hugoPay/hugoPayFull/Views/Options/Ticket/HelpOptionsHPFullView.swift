//
//  HelpOptionsHPFullView.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class HelpOptionsHPFullView: NSObject {
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var faqOption: UIView!
    @IBOutlet weak var ticketOption: UIView!
    
    @IBOutlet weak var faqTitle: UILabel!
    @IBOutlet weak var facSubtitle: UILabel!
    
    @IBOutlet weak var ticketTitle: UILabel!
    @IBOutlet weak var ticketSubtitle: UILabel!

    var view: UIView!
    
    var backFromHelp: (()-> Void)?
    
    var openFAQ: (()-> Void)?
    var openTicket: (()->())?
    
    func removeViews() {
        guard let view = self.view else { return }
        
        view.removeFromSuperview()
    }
    
    func prepareViews(_ vc_view: PullUpView) {
        let nib = Bundle.main.loadNibNamed("HelpOptionsHugoPayView", owner: self, options: nil)
        
        if let view = nib?.first as? UIView {
            vc_view.addSubview(view)
            var newHeight = vc_view.frame.height
            var safeAreaInsetsBottom: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                safeAreaInsetsBottom = vc_view.safeAreaInsets.bottom
                newHeight = vc_view.frame.height + vc_view.safeAreaInsets.bottom
            }
            
            let tapFAQ = UITapGestureRecognizer(target: self, action: #selector(doOpenFAQ))
            self.faqOption.isUserInteractionEnabled = true
            self.faqOption.addGestureRecognizer(tapFAQ)
            
            let tapTicket = UITapGestureRecognizer(target: self, action: #selector(doOpenTicket))
            self.ticketOption.isUserInteractionEnabled = true
            self.ticketOption.addGestureRecognizer(tapTicket)
            
            
            view.frame = CGRect(x: 0, y: vc_view.insets.top - safeAreaInsetsBottom, width: vc_view.frame.width, height: newHeight)
            
            self.view = view
        }
    }

    func configureTexts(_ texts: [ConfigOptionsHPFull]?){
        if let texts = texts {
            for text in texts {
                if let option = text.header?.first(where: {$0.type == "help"}) {
                    titleLbl.text = option.text ?? ""
                 }
                if let option = text.body?.first(where: {$0.type == "help_ask"}) {
                    faqTitle.text = option.title ?? ""
                    facSubtitle.text = option.comment ?? ""
                 }
                if let option = text.body?.first(where: {$0.type == "help_tkt"}) {
                    ticketTitle.text = option.title ?? ""
                    ticketSubtitle.text = option.comment ?? ""
                 }

            }
        }
        ticketTitle.isHidden = true
        ticketSubtitle.isHidden = true
    }
    
    @objc func doOpenFAQ(){
        openFAQ?()
    }
    
    @objc func doOpenTicket(){
        openTicket?()
    }
    
    @IBAction func goBack(_ sender: Any) {
        backFromHelp?()
    }
}
