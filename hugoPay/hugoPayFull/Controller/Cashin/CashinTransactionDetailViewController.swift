//
//  CashinTransactionDetailViewController.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/3/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift

protocol CashinTransactionDetail {
    func dismissSuccesController()
}

class CashinTransactionDetailViewController: UIViewController {
    @IBOutlet weak var labelAmountTransaction: UILabel!
    @IBOutlet weak var labelTransactionDate: UILabel!
    @IBOutlet weak var imageViewCardType: UIImageView!
    @IBOutlet weak var labelCardEnd: UILabel!
    @IBOutlet weak var labelAmountTransactionDetail: UILabel!
    
    lazy var viewModel: CashinTransactionDetailViewModel = {
        CashinTransactionDetailViewModel()
    }()
    
    let disposeBag = DisposeBag()
    
    var hugoId = ""
    
    var delegate: CashinTransactionDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
    }
    
    func assingTransactionID(with hugoId: String) {
        viewModel.transactionHugoId = hugoId
        fetchTransactionDetail()
    }
    
    // MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        dismiss(animated: true)
        delegate?.dismissSuccesController()
    }
    
    // MARK: - Functions
    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }
    
    fileprivate func fetchTransactionDetail() {
        showLoading()
        viewModel.getDetailTransactionHugoPay().asObservable()
            .subscribe(onNext: {[weak self] data in
                self?.hideLoading()
                if let success = data?.success, success, let transaction = data?.data {
                    self?.populateFields(with: transaction)
                }
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func populateFields(with transaction: DataDetailTransactionHPFull) {
        labelAmountTransaction.text = transaction.totalAmountLabel ?? ""
        labelTransactionDate.text = transaction.date ?? ""
        imageViewCardType.image = CreditCard.cardImageByString(with: transaction.cardBrand ?? "")
        labelCardEnd.text = transaction.cardNumber ?? ""
        labelAmountTransactionDetail.text = transaction.totalAmountLabel ?? ""
    }
}
