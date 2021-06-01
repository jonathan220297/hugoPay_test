//
//  TransactionsHPFullViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

protocol TransactionsHPFullDelegate {
    func reloadTransactionData(with transactionViewMore: TransactionViewMore?)
}

class TransactionsHPFullViewModel: NSObject {

    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared

    var allTransactions = [DataTransactionsHPFull]()

    var hideLoading: (()->())?
    var showLoading: (()->())?
    var emptyResult: ((Bool)->())?
    var showHPFullTransaction: ((UIViewController)->())?
    
    var transactionViewMore: TransactionViewMore?
    
    var delegate: TransactionsHPFullDelegate!

    func getTransactions() -> [DataTransactionsHPFull]{
        return allTransactions
    }

    func setRealTransactions(_ transactions: [DataTransactionsHPFull]){
        for transaction in transactions {
            if let t = transaction.transactions, t.count > 0{
                allTransactions.append(transaction)
            }
        }
    }

    func getTransactionsHugoPay(with today: Bool?, _ month: Bool?, previous: Bool?) -> BehaviorRelay<LatestTransactionsResponse?> {
         let apiResponse: BehaviorRelay<LatestTransactionsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(TransactionsListRequest(
            client_id: userManager.client_id ?? "",
            today: today,
            this_month: month,
            previous_transactions: previous
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let transactionhp):
                    if let data = transactionhp.data{
                        self.allTransactions = [DataTransactionsHPFull]()
                        self.setRealTransactions(data)
                    }
                    apiResponse.accept(transactionhp)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func getFilteredTransactionsHugoPay() -> BehaviorRelay<LatestTransactionsResponse?> {
        let apiResponse: BehaviorRelay<LatestTransactionsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(FilteredTransactionRequest(
            client_id: userManager.client_id ?? "",
            start_date: hugoPayData.startDateHPFFilter,
            end_date: hugoPayData.endDateHPFFilter,
            movement_type: hugoPayData.movementTypeHPFFilter,
            payment_type: hugoPayData.paymentTypeHPFFilter,
            start_amount: hugoPayData.startAmountHPFFilter,
            end_amount: hugoPayData.endAmountHPFFilter
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let transactionhp):
                    if let data = transactionhp.data{
                        self.allTransactions = [DataTransactionsHPFull]()
                        self.setRealTransactions(data)
                    }
                    apiResponse.accept(transactionhp)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }

    func getRequestHP() -> BehaviorRelay<LatestTransactionsResponse?> {
         let apiResponse: BehaviorRelay<LatestTransactionsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(TransactionsListRequest(
            client_id: userManager.client_id ?? "",
            today: nil,
            this_month: nil,
            previous_transactions: nil
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let transactionhp):
                    if let data = transactionhp.data{
                        self.allTransactions = [DataTransactionsHPFull]()
//                        self.setRealTransactions(data)
                    }
                    apiResponse.accept(transactionhp)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }

    func getTransactionsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHPFullCell", for: indexPath) as! TransactionHPFullCell
        cell.selectedBackgroundView?.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if  indexPath.section < allTransactions.count,
            let transactions = allTransactions[indexPath.section].transactions,
            indexPath.row < transactions.count {
            cell.config(transactions[indexPath.row])
        }

        return cell
    }
}

//MARK: - TableViewDeleate

extension TransactionsHPFullViewModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section < allTransactions.count,
            let transactions = allTransactions[indexPath.section].transactions,
            indexPath.row < transactions.count {
            let transaction = transactions[indexPath.row]
            
            if let movementTypeString = transaction.type,
               let movementType: VerifyHPFullTypeLayout = VerifyHPFullTypeLayout(rawValue: movementTypeString) {
                switch movementType {
                case .cash :
                    let vc = CashinTransactionDetailViewController.instantiate(fromAppStoryboard: .HugoPayFullCashIn)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.assingTransactionID(with: transaction.hugoID ?? "")
                    self.showHPFullTransaction?(vc)
                    break
                case .env:
                    let vc = SendMoneyTransactionDetailViewController.instantiate(fromAppStoryboard: .SendMoney)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.viewModel.transactionHugoId = transaction.hugoID ?? ""
                    vc.comesFromTransactionList = true
                    self.showHPFullTransaction?(vc)
                    break
                case .req:
                    let vc = RequestMoneyTransactionDetailViewController.instantiate(fromAppStoryboard: .RequestMoney)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.comesFromTransactionList = true
                    vc.viewModel.transactionHugoId = transaction.hugoID ?? ""
                    self.showHPFullTransaction?(vc)
                    break
                default:
                    let vc = DetailTransactionHPFullViewController.instantiate(fromAppStoryboard: .HugoPayFull)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.assignTransactionDetailID(hugoId: transaction.hugoID ?? "")
                    self.showHPFullTransaction?(vc)
                    break
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}

//MARK: - TableViewDataSource
extension TransactionsHPFullViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return allTransactions.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 35.0))
        sectionHeader.backgroundColor = .white

        let titleString = allTransactions[section].label ?? ""
        let sectionName = UILabel(frame: CGRect(x: 22, y: 0, width: sectionHeader.bounds.width - 44, height: sectionHeader.bounds.height))
        sectionName.text = titleString.uppercased()
        sectionName.textColor = .purpleTitle
        sectionName.font = UIFont.init(name: Fonts.Bold.rawValue, size: 13)

        sectionHeader.addSubview(sectionName)
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let viewMore = allTransactions[section].viewMore {
            if viewMore {
                let footerCell = tableView.dequeueReusableCell(withIdentifier: "cellTransactionFooter") as! TransactionFooterTableViewCell
                footerCell.buttonViewMore.addTarget(self, action: #selector(buttonViewMoreTapped(_:)), for: .touchUpInside)
                footerCell.buttonViewMore.tag = section
                return footerCell
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let viewMore = allTransactions[section].viewMore {
            if viewMore {
                return 35.0
            }
        }
        return 0.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < allTransactions.count
        {
            return allTransactions[section].transactions?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getTransactionsCell(tableView, cellForRowAt: indexPath)
    }
    
    @objc func buttonViewMoreTapped(_ sender: UIButton) {
        if let section = allTransactions[sender.tag].section {
            if section == "today" {
                transactionViewMore = .today
            } else if section == "month" {
                transactionViewMore = .month
            } else if section == "previous_transactions" {
                transactionViewMore = .previous
            } else {
                transactionViewMore = nil
            }
        }
        delegate.reloadTransactionData(with: transactionViewMore)
    }
}
