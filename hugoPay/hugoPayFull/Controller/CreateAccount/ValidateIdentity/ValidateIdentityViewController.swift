//
//  ValidateIdentityViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 19/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class ValidateIdentityViewController: UIViewController {

    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    @IBOutlet weak var hugoPayBtn: UIButton!

    lazy var viewModel: ValidateIdentityViewModel = {
        return ValidateIdentityViewModel()
    }()

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
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

    func configItems() {
        hugoPayBtn.makeHugoPayFullButton(title: "FINALIZAR")
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func finishCreateAccount(_ sender: Any) {
        createAccountHPFull()
    }

    func createAccountHPFull() {
        showLoading()
        viewModel.createAccountHPFull().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let _ = ccdata.success {
                        self?.successCreateAccount()
                    } else {
                        if let msg = ccdata.message {
                            showErrorCustom("Error", msg)
                        } else {
                            showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func successCreateAccount() {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.createAccount.successCreateAccountViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.hugoTabController = self.hugoTabController
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
