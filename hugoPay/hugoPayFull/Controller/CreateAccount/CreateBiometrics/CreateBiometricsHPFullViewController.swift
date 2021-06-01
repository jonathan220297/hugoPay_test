//
//  CreateBiometricsHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 19/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import LocalAuthentication
import RxRelay
import RxSwift

class CreateBiometricsHPFullViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    @IBOutlet weak var biometricsImage: UIImageView!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var ignoreBtn: UIButton!

    private let disposeBag = DisposeBag()

    lazy var viewModel: CreateBiometricsHPFullViewModel = {
        return CreateBiometricsHPFullViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        acceptBtn.makeHugoButton(title: "hp_lbl_account_allow_biometric".localizedString.uppercased())
        ignoreBtn.makeHugoClearButtonWithoutBorder(title: "hp_lbl_account_skip_biometric".localizedString.uppercased())
        configureFromBiometrics()
        configViewModel()
    }

    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }

    func configureFromBiometrics(){
        switch biometricType() {
        case BiometricType.face:
            biometricsImage.image = #imageLiteral(resourceName: "icon_face_id")
            titleLbl.text = String(format: "%@ Face ID", "hp_lbl_account_enable_biometric".localizedString)
        case BiometricType.touch:
            biometricsImage.image = #imageLiteral(resourceName: "icon_touch_id")
            titleLbl.text = String(format: "%@ Touch ID", "hp_lbl_account_enable_biometric".localizedString)
        default:
            biometricsImage.image = #imageLiteral(resourceName: "icon_touch_id")
            titleLbl.text = String(format: "%@ Touch ID", "hp_lbl_account_enable_biometric".localizedString)
        }

        subTitleLbl.text = "hp_lbl_account_desc_biometric".localizedString
    }

    func presentSuccesAlert() {
        let alert = UIAlertController(title: "Registro exitoso", message: "Se registro el ingreso con briometricos con éxito", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
            self.goToHugoPay()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()

        var authorizationError: NSError?
        let reason = "La autenticación es necesaria para entrar"

            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
                localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                    if success {
                        DispatchQueue.main.async() {
                            self.doUpdateBiometrics(true)
                        }
                    } else {
                        guard let error = evaluateError else {
                            return
                        }
                        print(error)
                    }
                }
            } else {
                guard let error = authorizationError else {
                    return
                }
                print(error)
        }
    }

    func doUpdateBiometrics(_ active: Bool){
        showLoading()
        viewModel.updateBiometrics(active).asObservable()
                .subscribe(onNext: {[weak self] (biometricsdata) in
                    guard let biometricsdata = biometricsdata else { return }
                    DispatchQueue.main.async {
                        self?.hideLoading()
                        if let success = biometricsdata.success, success {
                            self?.goToHugoPay()
                        } else {
                            if let msg = biometricsdata.message {
                                showErrorCustom("Error", msg)
                            } else {
                                showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                            }
                        }
                    }
                })
                .disposed(by: disposeBag)
    }

    func goToHugoPay() {
        self.dismiss(animated: true) {
            self.delegate?.dismiss()
        }
    }

    @IBAction func acceptBiometrics(_ sender: Any) {
        authenticationWithTouchID()
    }

    @IBAction func ignoreBiometrics(_ sender: Any) {
        doUpdateBiometrics(false)
    }
}
