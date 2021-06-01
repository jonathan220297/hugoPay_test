//
//  CashinMoneyConfirmation.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 25/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift

class CashinMoneyConfirmation: UIView {
    @IBOutlet weak var labelMoneyAmount: UILabel!
    @IBOutlet weak var labelOriginMoneyTitle: UILabel!
    @IBOutlet weak var viewAddCreditCard: UIView!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var viewCreditCardSelector: UIView!
    @IBOutlet weak var imageViewCreditType: UIImageView!
    @IBOutlet weak var labelCreditCardLastFour: UILabel!
    @IBOutlet weak var labelMoneyAmountCreditCard: UILabel!
    @IBOutlet weak var buttonConfirm: LoadingButton!
    
    let cardManager = CardManager.shared
    let userManager = UserManager.shared
    let cardSelector = CreditCard()
    
    var view: UIView!
    var pullUpView: PullUpView!
    
    var goCreditCardListViewController : (()->())?
    var goSuccessCashinViewController: ((_ hugoId: String?, _ balance: String?)->())?
    var goFailureCashinViewController: ((_ message: String?)->())?
    var showSimpleAlert: ((_ message: String)->())?
    
    lazy var viewModel: CashInMoneyConfirmationViewModel = {
        return CashInMoneyConfirmationViewModel()
    }()
    
    let disposeBag = DisposeBag()
    
    func removeViews() {
        guard let view = self.view else { return }
        
        view.removeFromSuperview()
    }

    func prepareViews(_ vc_view: PullUpView, _ money: Double?) {
        let nib = Bundle.main.loadNibNamed("CashinMoneyConfirmation", owner: self, options: nil)
        
        if let view = nib?.first as? UIView {
            pullUpView = vc_view
            vc_view.addSubview(view)
            let newHeight = vc_view.frame.height
            
            configureViewModel()
            configureInfo(with: money)
            configureCreditCard()
            
            view.frame = CGRect(x: 0, y: 0, width: vc_view.frame.width, height: newHeight)
            
            self.view = view
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonAddCreditCardTapped(_ sender: Any) {
        goCreditCardListViewController?()
    }
    
    @IBAction func buttonSelectCreditCardTapped(_ sender: Any) {
        goCreditCardListViewController?()
    }
    
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        processPayment()
    }
    
    // MARK: - Functions
    fileprivate func configureViewModel() {
        viewModel.showLoading = {[weak self] in
            self?.buttonConfirm.showLoading()
        }
        
        viewModel.hideLoading = {[weak self] in
            self?.buttonConfirm.hideLoading()
        }
    }
    
    func configureInfo(with money: Double?) {
        let moneyStr = viewModel.configureInfo(with: money)
        labelMoneyAmount.text = moneyStr
        labelMoneyAmountCreditCard.text = moneyStr
    }
    
    func configureCreditCard() {
        viewModel.getDefaultCreditCard { (card) in
            self.viewSeparator.isHidden = true
            self.viewCreditCardSelector.isHidden = true
            self.labelOriginMoneyTitle.isHidden = true
            self.viewAddCreditCard.isHidden = true
            let length = card?.cc_brand?.count ?? 0
            if length == 0 {
                self.labelOriginMoneyTitle.isHidden = false
                self.viewAddCreditCard.isHidden = false
                self.pullUpView.updateHeight(with: 355)
                return
            }
            if let card = card {
                self.labelCreditCardLastFour.text = card.cc_end ?? ""
                self.imageViewCreditType.image = CreditCard.cardImageByString(with: card.cc_brand)
                self.viewSeparator.isHidden = false
                self.viewCreditCardSelector.isHidden = false
                self.pullUpView.updateHeight(with: 375)
            } else {
                self.labelOriginMoneyTitle.isHidden = false
                self.viewAddCreditCard.isHidden = false
                self.pullUpView.updateHeight(with: 355)
            }
        }
    }
    
    func processPayment() {
        buttonConfirm.showLoading()
        viewModel.getDefaultCreditCard { (card) in
            let length = card?.cc_brand?.count ?? 0
            if length == 0 {
                self.buttonConfirm.hideLoading()
                self.showSimpleAlert?("hp_CashinMoneyConfirmation_CreditCardSelectionValidation".localized)
                return
            }
            if let card = card {
                if let moneyStr = self.labelMoneyAmount.text?.removeFormatAmount() {
                    let money = Double(moneyStr)
                    self.viewModel.processPaymentCashIn(with: money, card: card)
                        .asObservable()
                        .subscribe(onNext: { [weak self] data in
                            guard let data = (data) else { return }
                            self?.buttonConfirm.hideLoading()
                            if let sucess = data.success, sucess, let data = data.data {
                                self?.goSuccessCashinViewController?(data.hugo_id, data.balance)
                            } else {
                                self?.goFailureCashinViewController?(data.message)
                            }
                        })
                        .disposed(by: self.disposeBag)
                } else {
                    self.showSimpleAlert?("hp_CashinMoneyConfirmation_invalidAmount".localized)
                    self.buttonConfirm.hideLoading()
                }
            } else {
                self.showSimpleAlert?("hp_CashinMoneyConfirmation_CreditCardSelectionValidation".localized)
                self.buttonConfirm.hideLoading()
            }
        }
    }
    
    
}
