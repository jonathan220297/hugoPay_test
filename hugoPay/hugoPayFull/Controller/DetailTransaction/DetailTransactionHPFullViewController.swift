//
//  DetailTransactionHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class DetailTransactionHPFullViewController: UIViewController {

    @IBOutlet weak var titleDetailLbl: UILabel!
    @IBOutlet weak var idTransactionLbl: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var partnerLbl: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var bigAmountLbl: UILabel!
    @IBOutlet weak var cardNumberLab: UILabel!
    @IBOutlet weak var cardLogoImage: UIImageView!
    @IBOutlet weak var cardDebitLab: UILabel!
    @IBOutlet weak var cashbackLab: UILabel!
    @IBOutlet weak var totalTrxLab: UILabel!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var upView: UIView!

    private let disposeBag = DisposeBag()

    lazy var viewModel: DetailTransactionHPFullViewModel = {
        return DetailTransactionHPFullViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func assignTransactionDetailID(hugoId: String) {
        configViewModel()
        viewModel.transactionHugoId = hugoId
        getDetailHugoPay()
    }

    func populateFields(transaction: DataDetailTransactionHPFull) {
        titleDetailLbl.text = transaction.note ?? ""
        bigAmountLbl.text = transaction.totalAmountLabel ?? ""
        idTransactionLbl.text = transaction.hugoId ?? ""
        dateTimeLabel.text = transaction.date ?? ""
        partnerLbl.text = transaction.partnerName ?? ""
        locationLabel.text = transaction.locationName ?? ""
        cardNumberLab.text = transaction.cardNumber ?? ""
        cardDebitLab.text = transaction.cardAmountLabel ?? ""
        cashbackLab.text = transaction.cashbackLabel ?? ""

        let cardAmount = transaction.cardAmount ?? 0.0
        let cashbackAmount = transaction.cashback ?? 0.0
        let totalAmount = cardAmount + cashbackAmount
        let total = NSDecimalNumber(string: String(format: "\(totalAmount)"))
        totalTrxLab.text = NumberFormatter.localizedString(from: total, number: .currency)
    }

    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }

    func getDetailHugoPay(){
        showLoading()
        viewModel.getHPFTransactionDetails().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = ccdata.success, success, let transaction = ccdata.data {
                        self?.populateFields(transaction: transaction)

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

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        downView.layer.addShadowTopView()
        upView.layer.addShadowTopView()
    }
}
