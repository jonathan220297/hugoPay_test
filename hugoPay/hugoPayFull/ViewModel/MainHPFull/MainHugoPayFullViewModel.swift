//
//  MainHugoPayFullViewModel.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 28/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class MainHugoPayFullViewModel: NSObject {
    
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayFullData = HugoPayFullData.shared
    
    var userHugoPayFullCreditCards = [CCHugoPayFull]()
    var configurationsText: [ConfigOptionsHPFull]?
    var tutorialSteps: [TutorialSteps]?
    var selectedCC: CCHugoPayFull?
    var textsHugoPay: [HomeHPFullOptions]?
    var initTransactions = [DataTransactionsHPFull]()
    
    var collectionViewCC : UICollectionView?
    var collectionViewOptions : UICollectionView?
    
    var hideLoading: (()->())?
    var showLoading: (()->())?
    var openTopUp: (()->())?
    var openControl: (()->())?
    var openPayServices: (()->())?
    var setCurrentPage: ((Int)->())?
    var showHPFullTransaction: ((UIViewController)->())?

    // SET TUTORIAL FLAGS
    func setTutorialOne(tutorialOne: Bool) {
        hugoPayFullData.showTutorialOne = tutorialOne
    }

    func setTutorialTwo(tutorialTwo: Bool) {
        hugoPayFullData.showTutorialTwo = tutorialTwo
    }

    func setTutorialThree(tutorialThree: Bool) {
        hugoPayFullData.showTutorialThree = tutorialThree
    }

    // GET TUTORIAL FLAGS
    func getTutorialOne() -> Bool {
        return hugoPayFullData.showTutorialOne
    }

    func getTutorialTwo() -> Bool {
        return hugoPayFullData.showTutorialTwo
    }

    func getTutorialThree() -> Bool {
        return hugoPayFullData.showTutorialThree
    }
    
    func getCCs() -> [CCHugoPayFull] {
        return userHugoPayFullCreditCards
    }
    
    func getConfig() -> [ConfigOptionsHPFull]?{
        return configurationsText
    }

    func getInitTexts() -> [HomeHPFullOptions]?{
        return textsHugoPay
    }
    
    func getBiometrics() -> Bool{
        if let data = hugoPayFullData.hugoPayFullInit, let biometrics = data.biometrics {
            return biometrics
        }
        return false
    }

    func getTransaction() -> [DataTransactionsHPFull]? {
        return initTransactions
    }

    func setRealTransactions(_ transactions: [DataTransactionsHPFull]){
        for transaction in transactions {
            if let t = transaction.transactions, t.count > 0{
                initTransactions.append(transaction)
            }
        }
    }

    func getInitHugoPay() -> BehaviorRelay<GetInitialHPFullResponse?> {
         let apiResponse: BehaviorRelay<GetInitialHPFullResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(DoGetInitialHugoPayFull(
            country_name: userManager.country_code ?? "SV"
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let cchugo):
                    if let data = cchugo.data{
                        self.textsHugoPay = data
                    }
                    apiResponse.accept(cchugo)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }

    func getCCHugoPay() -> BehaviorRelay<CardsAvailablesResponse?> {
        userHugoPayFullCreditCards.removeAll()
         let apiResponse: BehaviorRelay<CardsAvailablesResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(CardsAvailablesRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let cchugo):
                    if let data = cchugo.data {
                        for card in data {
                            if card.cardNumber != nil {
                                self.userHugoPayFullCreditCards.append(card)
                            }
                        }
                    }
                    apiResponse.accept(cchugo)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func blockCCHPFull() -> BehaviorRelay<BlockCCHPFullResponse?> {
        let apiResponse: BehaviorRelay<BlockCCHPFullResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostHPFull(BlockCCHPFullRequest(
            isVirtualCard: true,
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let blockCCHPFull):
                    apiResponse.accept(blockCCHPFull)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func unlockCCHPFull() -> BehaviorRelay<UnlockCCHPFullResponse?> {
        let apiResponse: BehaviorRelay<UnlockCCHPFullResponse?> = BehaviorRelay(value: nil)
        apiClient.sendPostHPFull(UnlockCCHPFullRequest(
            isVirtualCard: true,
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let unlockCCHPFull):
                    apiResponse.accept(unlockCCHPFull)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func getBalanceHPFull() -> BehaviorRelay<BalanceHPFullResponse?> {
        let apiResponse: BehaviorRelay<BalanceHPFullResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(BalanceHPFullRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let balanceResponse):
                    apiResponse.accept(balanceResponse)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }

    func getCashbackBalance() -> BehaviorRelay<CashbackBalanceResponse?> {
        let apiResponse: BehaviorRelay<CashbackBalanceResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(CashbackBalanceRequest(
            client_id: userManager.client_id ?? "",
            country_name: userManager.country_code ?? "SV"
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let cashbackBalanceResponse):
                    apiResponse.accept(cashbackBalanceResponse)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func getConfigHugoPay() -> BehaviorRelay<ConfigurationsResponse?> {
         let apiResponse: BehaviorRelay<ConfigurationsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(ConfigurationsRequest(
            country_name: userManager.country_code ?? "SV"
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let confighp):
                    if let data = confighp.data{
                        self.configurationsText = data
                    }
                    apiResponse.accept(confighp)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    func updateBiometrics(_ active : Bool) -> BehaviorRelay<BiometricsHugoPayFullResponse?> {
         let apiResponse: BehaviorRelay<BiometricsHugoPayFullResponse?> = BehaviorRelay(value: nil)
         apiClient.sendPostHPFull(BiometricsHugoPayFullRequest(
            client_id: userManager.client_id ?? "",
            app_id: UIDevice.current.identifierForVendor?.uuidString ?? "",
            biometrics: active
         )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let payservices):
                    apiResponse.accept(payservices)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }

    func getTransactionsHugoPay() -> BehaviorRelay<LatestTransactionsResponse?> {
         let apiResponse: BehaviorRelay<LatestTransactionsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(LatestTransactionsRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let transactionhp):
                    if let data = transactionhp.data {
                        self.initTransactions = [DataTransactionsHPFull]()
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

    func getTutorialSteps() -> BehaviorRelay<TutorialStepsResponse?> {
         let apiResponse: BehaviorRelay<TutorialStepsResponse?> = BehaviorRelay(value: nil)
        apiClient.sendGetHPFull(TutorialStepsRequest(
            client_id: userManager.client_id ?? ""
        )) { response in
            DispatchQueue.main.async {
                self.hideLoading?()
                switch response {
                case .success(let steps):
                    if let data = steps.data {
//                        self.setTutorialOne(tutorialOne: data[0].tutorial_1 ?? true)
//                        self.setTutorialTwo(tutorialTwo: data[1].tutorial_2 ?? true)
//                        self.setTutorialThree(tutorialThree: data[2].tutorial_3 ?? true)
                        self.tutorialSteps = data
                    }
                    apiResponse.accept(steps)
                case .failure(let error):
                    showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
    
    private func findCenterIndex() -> IndexPath?{
        let collectionOrigin = collectionViewCC!.bounds.origin
        let collectionWidth = collectionViewCC!.bounds.width
        var centerPoint: CGPoint!
        var newX: CGFloat!
        if collectionOrigin.x > 0 {
            newX = collectionOrigin.x + collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y + 10)
        } else {
            newX = collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
        }

        let index = collectionViewCC!.indexPathForItem(at: centerPoint)
        
        print("NewX: \(newX), centerPoint: \(centerPoint) index: \(index)")
        
        return index
    }
}

//MARK: - GetCells
extension MainHugoPayFullViewModel {

    func getTransactionsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHPFullCell", for: indexPath) as! TransactionHPFullCell
        cell.selectedBackgroundView?.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if  indexPath.section < initTransactions.count, let transactions = initTransactions[indexPath.section].transactions, indexPath.row < transactions.count {
            cell.config(transactions[indexPath.row])
        }

        return cell
    }

    func getCCHugoPayCell(_ collectionView: UICollectionView,
                          cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CardHPFullCollectionViewCell",
            for: indexPath) as? CardHPFullCollectionViewCell {
            
            cell.selectedBackgroundView?.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            
            if indexPath.row < userHugoPayFullCreditCards.count{
                cell.config(userHugoPayFullCreditCards[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func getOptionsHugoPayCell(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell
    {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionHPFullCollectionViewCell", for: indexPath) as? OptionHPFullCollectionViewCell {
            if let options = textsHugoPay, indexPath.row < options.count{
                switch indexPath.row {
                case 0:
                    if let option = options.first(where: {$0.type == "recharge"}) {
                        cell.config(option)
                    }
                case 1:
                    if let option = options.first(where: {$0.type == "control"}) {
                        cell.config(option)
                    }
                case 2:
                    if let option = options.first(where: {$0.type == "services"}) {
                        cell.config(option)
                    }
                default:
                    break
                }
            }
            cell.selectedBackgroundView?.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - CollectionViewDeleate
extension MainHugoPayFullViewModel: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let cv = scrollView as? UICollectionView, cv == collectionViewCC {
            if let indexPath = findCenterIndex() {
                if (cv.cellForItem(at: indexPath) as? CardHPFullCollectionViewCell) != nil {
                    cv.selectItem(at: indexPath,
                                  animated: true,
                                  scrollPosition: .centeredHorizontally)
                        self.setCurrentPage?(indexPath.row)
                        selectedCC = userHugoPayFullCreditCards[indexPath.row]
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cv = scrollView as? UICollectionView, cv == collectionViewCC {
            if let indexPath = findCenterIndex() {
                if (cv.cellForItem(at: indexPath) as? CardHPFullCollectionViewCell) != nil {
                    cv.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                    self.setCurrentPage?(indexPath.row)
                    selectedCC = userHugoPayFullCreditCards[indexPath.row]
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? CardHPFullCollectionViewCell {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.setCurrentPage?(indexPath.row)
            selectedCC = userHugoPayFullCreditCards[indexPath.row]
        }

        if let cv = collectionViewOptions, cv == collectionView {
            switch indexPath.row {
            case 0:
                openTopUp?()
            case 1:
                openControl?()
            case 2:
                openPayServices?()
            default:
                break
            }
        }
    }
}

//MARK: - CollectionViewDataSource
extension MainHugoPayFullViewModel: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cv = collectionViewCC, cv == collectionView{
            return 1
        }
        if let cv = collectionViewOptions, cv == collectionView{
            if let _ = self.textsHugoPay {
                return 3
            }
            return 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cv = collectionViewCC, cv == collectionView{
            return getCCHugoPayCell(collectionView, cellForRowAt: indexPath)
        }
        if let cv = collectionViewOptions, cv == collectionView{
            return getOptionsHugoPayCell(collectionView, cellForRowAt: indexPath)
        }
        return UICollectionViewCell()
    }
}

//MARK: - CollectionViewFlowDelegate
extension MainHugoPayFullViewModel: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let cv = collectionViewCC, cv == collectionView {
                return CGSize(width: CGFloat(cv.frame.size.width - 40), height: CGFloat(170.0))
            }
            if let cv = collectionViewOptions, cv == collectionView{
                let itemsPerRow = 3
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                flowLayout.minimumInteritemSpacing = 2.0
                let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1)) - 100
                let size = Int((cv.bounds.width - totalSpace) / CGFloat(itemsPerRow))

                return CGSize(width: CGFloat(size), height: 50)
            }
            return CGSize()
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2.0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if let cv = collectionViewCC, cv == collectionView {
                let edge : CGFloat = 50.0
                              
                return UIEdgeInsets.init(top: 0.0, left: edge, bottom: 0.0, right: edge)
            }
            return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
}

//MARK: - TableViewDeleate

extension MainHugoPayFullViewModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section < initTransactions.count,
            let transactions = initTransactions[indexPath.section].transactions,
            indexPath.row < transactions.count {
            let transaction = transactions[indexPath.row]

            if let movementTypeString = transaction.type,
               let movementType: VerifyHPFullTypeLayout = VerifyHPFullTypeLayout(rawValue: movementTypeString) {
                switch movementType {
                case .cash :
                    let vc = CashinTransactionDetailViewController.instantiate(fromAppStoryboard: .HugoPayFullCashIn)
                    vc.modalPresentationStyle = .fullScreen
                    vc.assingTransactionID(with: transaction.hugoID ?? "")
                    self.showHPFullTransaction?(vc)
                    break
                case .env:
                    let vc = SendMoneyTransactionDetailViewController.instantiate(fromAppStoryboard: .SendMoney)
                    vc.modalPresentationStyle = .fullScreen
                    vc.viewModel.transactionHugoId = transaction.hugoID ?? ""
                    vc.comesFromTransactionList = true
                    self.showHPFullTransaction?(vc)
                    break
                case .req:
                    let vc = RequestMoneyTransactionDetailViewController.instantiate(fromAppStoryboard: .RequestMoney)
                    vc.modalPresentationStyle = .fullScreen
                    vc.comesFromTransactionList = true
                    vc.viewModel.transactionHugoId = transaction.hugoID ?? ""
                    self.showHPFullTransaction?(vc)
                    break
                default:
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

extension MainHugoPayFullViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return initTransactions.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < initTransactions.count
        {
            return initTransactions[section].transactions?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getTransactionsCell(tableView, cellForRowAt: indexPath)
    }
}
