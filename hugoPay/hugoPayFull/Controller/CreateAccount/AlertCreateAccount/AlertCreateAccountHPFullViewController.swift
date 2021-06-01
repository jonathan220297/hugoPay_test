//
//  AlertCreateAccountHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 18/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class AlertCreateAccountHPFullViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    @IBOutlet weak var beginsWithHugoPayTitle: UILabel!
    @IBOutlet weak var beginsWithHugoPayDescription: UILabel!
    @IBOutlet weak var beginsWithHugoPayFooter: UILabel!
    @IBOutlet weak var hugoPayBtn: UIButton!
    @IBOutlet weak var termsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }

    func configItems() {
        let hpTitle =  String(format: "Inicia con hugoPay")

        let attributedTitle = NSAttributedString.title(
            hpTitle,
            font: UIFont.init(name: Fonts.Medium.rawValue, size: 18) ?? UIFont(),
            color: UIColor(red: 46.0 / 255.0, green: 16.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0),
            kern: 0
        )

        let mutableAttribuedTitle = NSMutableAttributedString(
            attributedString: attributedTitle
        )

        mutableAttribuedTitle.bold(
        "hugo",
        font: UIFont.init(name: Fonts.Ultra.rawValue, size: 18) ?? UIFont())

        beginsWithHugoPayTitle.attributedText = mutableAttribuedTitle

        let hpFullDescription = String(format: "Para comenzar a disfrutar nuestros productos\nprimero debes crear una cuenta en hugoPay.\nToma en cuenta que es una cuenta financiera,\nnecesitamos que los datos sean exactos.")

        let attributedDescription = NSAttributedString.title(
            hpFullDescription,
            font: UIFont.init(name: Fonts.Book.rawValue, size: 13) ?? UIFont(),
            color: UIColor(red: 128.0 / 255.0, green: 120.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0),
            kern: 0
        )

        let mutableAttribuedDescription = NSMutableAttributedString(
            attributedString: attributedDescription
        )

        mutableAttribuedDescription.bold(
        "hugo",
        font: UIFont.init(name: Fonts.Ultra.rawValue, size: 13) ?? UIFont())

        beginsWithHugoPayDescription.attributedText = mutableAttribuedDescription

        hugoPayBtn.makeHugoPayFullButton(title: "COMENZAR")

        let termsTextLocalized = String(format: "El ingresar crear tu cuenta aceptas los\n%@.", " términos y condiciones.")

        let attributedTerms = NSAttributedString.title(
            termsTextLocalized,
            font: UIFont.init(name: Fonts.Book.rawValue, size: 11) ?? UIFont(),
            color: UIColor(red: 128.0 / 255.0, green: 120.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0),
            kern: 0
        )

        let mutableAttribuedTerms = NSMutableAttributedString(
            attributedString: attributedTerms
        )

        mutableAttribuedTerms.bold(
        "términos",
        font: UIFont.init(name: Fonts.Bold.rawValue, size: 11) ?? UIFont())

        mutableAttribuedTerms.bold(
        "condiciones",
        font: UIFont.init(name: Fonts.Bold.rawValue, size: 11) ?? UIFont())

        termsLabel.attributedText = mutableAttribuedTerms
        termsLabel.isUserInteractionEnabled = true

        let termsTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnTermsAndConditionsAction(_:)))
        termsTap.numberOfTouchesRequired = 1
        termsTap.numberOfTapsRequired = 1
        termsLabel.addGestureRecognizer(termsTap)
    }

    @objc func didTapOnTermsAndConditionsAction(_ sender: UITapGestureRecognizer) {
        var termsWord = "terms"
        let spanishWord = "es"
        let deviceLang: String = Locale.current.languageCode ?? spanishWord

        if deviceLang != spanishWord {
            termsWord += "En"
        }

//        if let vc = R.storyboard.hugoPay.showTermsConditionsViewController() {
//            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .crossDissolve
//
//            self.present(vc, animated: true, completion: {
//                vc.loadContentWith(url: String(format: "https://hugo-pay-landing-2fntzxamka-uk.a.run.app/%@", termsWord))
//            })
//        }
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func nextStepCreateAccount(_ sender: Any) {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.createAccount.createAccountBasicInfoViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
