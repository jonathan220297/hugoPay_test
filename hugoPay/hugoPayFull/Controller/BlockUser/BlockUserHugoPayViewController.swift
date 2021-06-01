//
//  BlockUserHugoPayViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import SnapKit

class BlockUserHugoPayViewController: UIViewController {
    
    // MARK: - IBoutlets
    
    @IBOutlet weak var screenTitleLbl: UILabel!
    @IBOutlet weak var screenSubtitleLbl: UILabel!
    @IBOutlet weak var recoverButton: UIButton!
    
    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    private var overlay = UIControl()

    private lazy var pullUpView: PullUpView = {
        let pullUpView = PullUpView(frame: CGRect.zero)
        pullUpView.backgroundColor = UIColor.white
        view.addSubview(pullUpView)
        return pullUpView
    }()

    private lazy var resetPinOptionsView: ResetPinOptionsHugoPayFullView? = ResetPinOptionsHugoPayFullView()

    lazy var viewModel: BlockUserHugoPayViewModel = {
        return BlockUserHugoPayViewModel()
    }()

     private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        setupLabels()
    }

    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }
    
    func setupLabels() {
        screenTitleLbl.text = "hp_full_reset_pin_locked_account_title".localizedString
        screenSubtitleLbl.text = "hp_full_reset_pin_locked_account_subtitle".localizedString
        recoverButton.setTitle("hp_full_reset_pin_locked_account_recover_button".localizedString,
                                         for: .normal)
    }

    @IBAction func goBack(_ sender: Any) {
        goToHome()
    }

    func goToHome() {
        self.dismiss(animated: true, completion: nil)
    }

    func doPinRecoveryService(recoverType: String) {
        showLoading()
        viewModel.pinRecoveryService(recoverMethodType: recoverType).asObservable()
        .subscribe(onNext: {[weak self] (blockUserData) in
            guard let blockUserData = blockUserData else { return }
            DispatchQueue.main.async {
                self?.hideLoading()
                if let success = blockUserData.success, success {
                    self?.showResetPinView(for: recoverType)
                }else {
                    if let msg = blockUserData.message {
                        showErrorCustom("Error", msg)
                    } else {
                        showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    }
                }
            }
        })
        .disposed(by: disposeBag)
    }

    func showResetPinView(for recoverType: String) {
        self.dismiss(animated: true) {
            if let vc = R.storyboard.hugoPayFull.resetPasswordHPFullViewController() {
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self.delegate
                vc.recoverType = recoverType
                vc.codeSentTo = self.codeSentTo(for: recoverType)
                self.hugoTabController?.present(vc, animated: true, completion: nil)
            }
        }
    }

    @IBAction func openOptionsResetPassword(_ sender: Any) {
        openOptionsResetPassword()
    }

    func openOptionsResetPassword(){
        showOverlay()
        pullUpView.setup(with: 200)
        resetPinOptionsView?.prepareViews(pullUpView)
        resetPinOptionsView?.view.layer.roundCorners(radius: 20.0)
        resetPinOptionsView?.containerView.layer.roundCorners(radius: 20.0)
        resetPinOptionsView?.goSendEmail = {[weak self] in
            self?.doPinRecoveryService(recoverType: "EMAIL")
        }
        resetPinOptionsView?.goSendSms = {[weak self] in
            self?.doPinRecoveryService(recoverType: "SMS")
        }

        resetPinOptionsView?.configureTexts(userEmail: viewModel.getEmail(), userNumber: viewModel.getPhone())

        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    func codeSentTo(for recoverType: String) -> String {
        var codeSentTo = ""
        if recoverType == "EMAIL" {
            codeSentTo = viewModel.getEmail()
        } else if recoverType == "SMS" {
            codeSentTo = viewModel.getPhone()
        }
        
        return codeSentTo
    }
}

//MARK:- Options PullUp View

extension BlockUserHugoPayViewController {

    func showOverlay() {
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        view.addSubview(overlay)

        overlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        UIView.animate(withDuration: 0.3) {
            self.overlay.alpha = 0.5
        }

        overlay.addTarget(self, action: #selector(hideOverlay), for: .touchUpInside)
    }

    @objc func hideOverlay() {
        if overlay.superview != nil {
            self.pullUpView.hide(animated: true)
            removeViewsFromPullUp()
            UIView.animate(withDuration: 0.2, animations: {
                self.overlay.alpha = 0
            }, completion: { (success) in
                self.overlay.removeFromSuperview()
            })
        }
    }

    func removeViewsFromPullUp(){
        self.resetPinOptionsView?.removeViews()
    }
}
