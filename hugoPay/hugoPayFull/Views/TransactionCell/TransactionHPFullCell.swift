//
//  TransactionHPFullCell.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 30/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import Nuke

class TransactionHPFullCell: UITableViewCell {
    var userManager = UserManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(_ data : TransactionsHPFull){
        if let url = URL(string: data.logo ?? ""){
            Nuke.loadImage(with: url, into: logo)
        } else {
            if let movementType = data.movementType {
                if movementType == TransactionMovementType.expense.rawValue {
                    logo.setImageForName("\(userManager.name ?? "") \(userManager.last_name ?? "")", backgroundColor: UIColor.strongPurple1, circular: true, textAttributes: nil)
                } else {"\(userManager.name ?? "") \(userManager.last_name ?? "")"
                    if let nameParts = data.issuerName?.split(separator: " ") {
                        logo.setImageForName("\(nameParts.first ?? "") \(nameParts.last ?? "")", backgroundColor: UIColor.strongPurple1, circular: true, textAttributes: nil)
                    }
                }
            }
        }
        logo.makeRounded()
        detail.text = data.label ?? ""
        dateTime.text = data.date ?? ""
        amountLbl.text = data.amount ?? ""
        
        let layout = VerifyHPFullTypeLayout(rawValue: data.type ?? "") ?? .env
        
        switch layout {
        case .env, .pos, .ret, .cca, .qr:
            amountLbl.text = data.amount ?? ""
            amountLbl.textColor = .burntSienna
            if layout == .env {
                amountLbl.textColor =  data.movementType == TransactionMovementType.expense.rawValue
                    ? .burntSienna
                    : .greenMint
            }
            if layout == .qr {
                amountLbl.textColor = data.status == TransactionHPFullStatus.refund.rawValue
                    ? .greenMint
                    : .burntSienna
            }
        case .req:
            amountLbl.text = data.amount ?? ""
            amountLbl.textColor = .graySuit
        case .dep, .cash:
            amountLbl.text = data.amount ?? ""
            amountLbl.textColor = .greenMint
        }
    }
}

extension UIImageView {
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
