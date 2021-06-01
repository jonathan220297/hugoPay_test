//
//  CreatePinSuccessHPFViewController.swift
//  Hugo
//
//  Created by Carlos Landaverde on 3/8/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import LocalAuthentication
import RxRelay
import RxSwift

class CreatePinSuccessHPFViewController: UIViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: MainHPFullViewControllerDelegate?
    var hugoTabController: UITabBarController?
    
    lazy var viewModel: CreateBiometricsHPFullViewModel = {
        return CreateBiometricsHPFullViewModel()
    }()
    
    private let disposeBag = DisposeBag()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.font = UIFont.init(name: Fonts.Bold.rawValue, size: 18)
        titleLabel.textColor = .hpfPurpleMainTitle
        
        continueBtn.layer.cornerRadius = 23.5
        continueBtn.layer.masksToBounds = true
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.backgroundColor = .hpfPurpleMainButton
        continueBtn.addTarget(self, action: #selector(didTapContinueBtn), for: .touchUpInside)
    }
    
    @objc private func didTapContinueBtn() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            goToBiometrics()
        } else {
            doUpdateBiometrics(false)
        }
    }
    
    func goToBiometrics() {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.createAccount.createBiometricsHPFullViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func goToHugoPay() {
        self.dismiss(animated: true) {
            self.delegate?.dismiss()
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
}
