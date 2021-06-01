//
//  TermsHPFullControllerViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 29/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import WebKit

class TermsHPFullControllerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var mustAcceptView: UIView!
    @IBOutlet weak var constraingBottomTerms: NSLayoutConstraint!
    
    @IBOutlet weak var acceptTermsImage: UIImageView!
    @IBOutlet weak var acceptBtn: UIButton!
    
    lazy var viewModel: TermsAndConditionsViewModel = {
        return TermsAndConditionsViewModel()
    }()
    
    var acceptedTerms = false
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }
    
    
    func verifyPendingTransaction(_ active: Bool){
        showLoading()
        viewModel.updateAcceptedTerms(active).asObservable()
                .subscribe(onNext: {[weak self] (biometricsdata) in
                    guard let biometricsdata = biometricsdata else { return }
                    DispatchQueue.main.async {
                        self?.hideLoading()
                        if let success = biometricsdata.success, success {
//                            self?.presentSuccesAlert()
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
    
    func goToRegisterHugoPay(){
//        if let vc = R.storyboard.hugoPay.createPinHugoPayViewController() {
//            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
    
    }
    
    @IBAction func doAcceptTerms(_ sender: Any) {
        if acceptedTerms{
            goToRegisterHugoPay()
        } else {
            
        }
    }
    
}
