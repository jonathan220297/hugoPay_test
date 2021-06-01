//
//  RequestMoneyTransactionDetailViewController.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/15/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import RxSwift
import UIKit

class RequestMoneyTransactionDetailViewController: UIViewController {
    
    
    // MARK - IBOutlets
    
    // Transaction Data IBOutlets
    @IBOutlet weak var transactionNoteLbl: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionContactLb: UILabel!
    @IBOutlet weak var transactionPhoneNumberLbl: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var transactionStatusLbl: UILabel!
    @IBOutlet weak var transactionTotalAmount: UILabel!
    
    @IBOutlet weak var cardLogoImage: UIImageView!
    
    // View structure IBOutlets
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var upView: UIView!
    
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    lazy var viewModel: DetailTransactionHPFullViewModel = {
        return DetailTransactionHPFullViewModel()
    }()
    
    var delegate: SendMoneyDelegate?
    var comesFromTransactionList = false
        
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        getTransactionDetails()
    }
    
    private func prepareView(with transactionDetails: RequestMoneyTransactionDetailsData) {
        transactionAmount.text = transactionDetails.amount
        transactionTotalAmount.text = transactionDetails.amount
        transactionNoteLbl.text = transactionDetails.note
        transactionDate.text = transactionDetails.registerDate
        transactionContactLb.text = transactionDetails.receiverName
        transactionPhoneNumberLbl.text = transactionDetails.phone
        transactionStatusLbl.text = transactionDetails.status?.uppercased()
    }
    
    private func configureViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }
    
    private func getTransactionDetails() {
        showLoading()
        viewModel
            .getRequestMoneyTransactionDetails()
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                guard let self = self,
                      let response = response else { return }
                DispatchQueue.main.async {
                    self.hideLoading()
                    if let success = response.success, success,
                       let transactionDetails = response.data {
                        self.prepareView(with: transactionDetails)
                    } else {
                        self.simpleAlert(title: "Sorry".localizedString, message: response.message)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Actions
    
    @IBAction func goBack(_ sender: Any) {
        if !comesFromTransactionList {
            self.presentingViewController?
                .presentingViewController?
                .dismiss(animated: true, completion: nil)
            delegate?.dismissP2PView()
        } else {
            dismiss(animated: true)
        }
    }
}
