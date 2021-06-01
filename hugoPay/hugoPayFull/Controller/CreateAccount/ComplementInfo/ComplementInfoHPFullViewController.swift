//
//  ComplementInfoHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 18/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class ComplementInfoHPFullViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    @IBOutlet weak var hugoPayBtn: UIButton!

    @IBOutlet weak var usCitizenTrue: UIView!
    @IBOutlet weak var usCitizenTrueImg: UIImageView!
    @IBOutlet weak var usCitizenFalse: UIView!
    @IBOutlet weak var usCitizenFalseImg: UIImageView!

    @IBOutlet weak var exposeTrue: UIView!
    @IBOutlet weak var exposeTrueImg: UIImageView!
    @IBOutlet weak var exposeFalse: UIView!
    @IBOutlet weak var exposeFalseImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }

    func configItems() {
        hugoPayBtn.makeHugoPayFullButton(title: "SIGUIENTE")

        let usCitizenTrueTap = UITapGestureRecognizer(target: self, action: #selector(usCitizenTrueButtonAction(_:)))
        usCitizenTrue.addGestureRecognizer(usCitizenTrueTap)

        let usCitizenFalseTap = UITapGestureRecognizer(target: self, action: #selector(usCitizenFalseButtonAction(_:)))
        usCitizenFalse.addGestureRecognizer(usCitizenFalseTap)

        let exposeTrueTap = UITapGestureRecognizer(target: self, action: #selector(exposeTrueButtonAction(_:)))
        exposeTrue.addGestureRecognizer(exposeTrueTap)

        let exposeFalseTap = UITapGestureRecognizer(target: self, action: #selector(exposeFalseButtonAction(_:)))
        exposeFalse.addGestureRecognizer(exposeFalseTap)
    }

    @IBAction func nextStepCreateAccount(_ sender: Any) {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.createAccount.validateIdentityViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func usCitizenTrueButtonAction(_ sender: UITapGestureRecognizer) {
        usCitizenTrueImg.image = UIImage(named: "tarjeta_pt_check")
        usCitizenFalseImg.image = UIImage(named: "tarjeta_pt_unchek")
    }

    @objc func usCitizenFalseButtonAction(_ sender: UITapGestureRecognizer) {
        usCitizenTrueImg.image = UIImage(named: "tarjeta_pt_unchek")
        usCitizenFalseImg.image = UIImage(named: "tarjeta_pt_check")
    }

    @objc func exposeTrueButtonAction(_ sender: UITapGestureRecognizer) {
        exposeTrueImg.image = UIImage(named: "tarjeta_pt_check")
        exposeFalseImg.image = UIImage(named: "tarjeta_pt_unchek")
    }

    @objc func exposeFalseButtonAction(_ sender: UITapGestureRecognizer) {
        exposeTrueImg.image = UIImage(named: "tarjeta_pt_unchek")
        exposeFalseImg.image = UIImage(named: "tarjeta_pt_check")
    }
}
