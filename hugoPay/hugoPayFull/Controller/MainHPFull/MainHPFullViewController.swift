//
//  MainHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 28/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import LocalAuthentication
import Nuke
import SnapKit

protocol MainHPFullViewControllerDelegate: class {
    
    func dismiss() -> Void
}

class MainHPFullViewController: UIViewController {
    
    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    
    var displayCardIndex: Int = 0
    
    var cardStatus: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var hugoPayFullCreditCards: UICollectionView!
    @IBOutlet weak var ccPageControlBarsBox: UIView!
    @IBOutlet weak var switchBlockCCHPFull: UIImageView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var cashbackLbl: UILabel!
    @IBOutlet weak var cashBackView: UIView!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var optionsButtonsBox: UIView!
    @IBOutlet weak var transactionsTableView: UITableView!
    
    let userManager = UserManager.shared

    let ccPageControlBars: PageControlBars = {
        let bars = PageControlBars()
        bars.currentBarColor = .purpleTitle
        bars.barColor = .purpleTitleLight
        return bars
    }()
    
    let ccScrollViewBox: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.showsHorizontalScrollIndicator = false
        scroll.clipsToBounds = false
        scroll.layer.masksToBounds = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    private lazy var pullUpView: PullUpView = {
        let pullUpView = PullUpView(frame: CGRect.zero)
        pullUpView.backgroundColor = UIColor.white
        self.view.addSubview(pullUpView)
//        view.addSubview(pullUpView)

        return pullUpView
    }()

    private var emptyView: UIView!
    private var messageIsEmpty: UILabel!
    
    private lazy var optionsMainView: OptionsHugoPayFullView? = OptionsHugoPayFullView()
    private lazy var optionsSecurityView: SecurityOptionsHugoPayFullView? = SecurityOptionsHugoPayFullView()
    private lazy var optionsTicketView: HelpOptionsHPFullView? = HelpOptionsHPFullView()
    
    // MARK: - Send Money Views
    private lazy var sendMoneyView: SendMoneyView? = SendMoneyView()
    private lazy var sendMoneyConfirmationView: SendMoneyConfirmationView? = SendMoneyConfirmationView()
    
    
    // MARK: = Request Money Views
    private lazy var requestMoneyView: RequestMoneyView? = RequestMoneyView()
    private lazy var requestMoneyConfirmationView: RequestMoneyConfirmationView? = RequestMoneyConfirmationView()
    
    private lazy var cashinMoneyIncome: CashInMoneyIncome? = CashInMoneyIncome()
    private lazy var cashinMoneyConfirmation: CashinMoneyConfirmation? = CashinMoneyConfirmation()
    
    lazy var viewModel: MainHugoPayFullViewModel = {
        return MainHugoPayFullViewModel()
    }()
    
    private let disposeBag = DisposeBag()
    
    private var overlay = UIControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViewModel()
        configureTableView()
        configurePageControlBars()
        configureCCCollectionView()
        configureOptionsCollectionView()
        configureOptionsButtonsBox()
        configureBannerShape()
        verifyTutorialStatus()
        configureObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMainInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        hideOverlay()
    }
    
    fileprivate func configureBannerShape() {
        viewBanner.addBottomRoundedEdge()
    }
    
    func configViewModel(){
        viewModel.collectionViewCC = hugoPayFullCreditCards
        viewModel.collectionViewOptions = optionsCollectionView
        
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
        viewModel.setCurrentPage = { [weak self] (page) in
            self?.ccPageControlBars.assignCurrentPage(index: page)
        }
        viewModel.showHPFullTransaction = { [weak self] (vc) in
            self?.showHPFullTransaction(vc: vc)
        }
        viewModel.openPayServices = { [weak self] () in
//            self?.openPayServices()
        }
        viewModel.openTopUp = { [weak self] () in
//            self?.openTopUp()
        }
        viewModel.openControl = { [weak self] () in
//            self?.openControl()
        }
    }
    
    fileprivate func configureObservers() {
        NotificationCenter.default.addObserver(forName: .showCashinFromTutorial, object: nil, queue: nil) {[weak self] _ in
            self?.openCashIn()
        }
    }

    func showHPFullTransaction(vc: UIViewController) {
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    func configureTableView() {
        self.transactionsTableView.backgroundColor = UIColor.clear

        self.transactionsTableView.tableHeaderView = UIView()
        self.transactionsTableView.tableFooterView = UIView()
        self.transactionsTableView.backgroundView = self.emptyView

        self.transactionsTableView.estimatedRowHeight = 60
        self.transactionsTableView.separatorStyle = .none
        self.transactionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

        self.transactionsTableView.register(UINib(nibName: "TransactionHPFullCell", bundle: nil) , forCellReuseIdentifier: "TransactionHPFullCell")
        self.transactionsTableView.dataSource = self.viewModel
        self.transactionsTableView.delegate = self.viewModel

        self.drawIsEmptyView()
    }

    func drawIsEmptyView()
    {
        if let table = transactionsTableView {
            messageIsEmpty = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            messageIsEmpty.textAlignment = .left
            messageIsEmpty.font = UIFont(name: Fonts.Bold.rawValue, size: 13.0)
            messageIsEmpty.textColor = UIColor(hex: Colors.hugoGray.rawValue)
            messageIsEmpty.adjustsFontSizeToFitWidth = true
            messageIsEmpty.numberOfLines = 2
            messageIsEmpty.textAlignment = .center

            let line = UIView(frame: CGRect(x: 16, y: table.frame.size.height*0.2, width: table.frame.size.width - 32, height: 2))
            line.backgroundColor = UIColor(hex: Colors.hugoGray.rawValue)

            let imageView = UIImageView(image: #imageLiteral(resourceName: "empty_state_transaction_hugopay"))
            imageView.contentMode = .scaleAspectFit
            let screenSize = UIScreen.main.bounds

            emptyView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height:  table.frame.size.height))
            imageView.frame = CGRect(x: (emptyView.frame.size.width / 2) - (180.0 / 2), y: 30.0, width: 180.0, height: 140.0)
            messageIsEmpty.frame = CGRect(x: emptyView.frame.size.width*0.15, y: 200.0, width: emptyView.frame.size.width*0.7, height:  44.0)

            emptyView.addSubview(messageIsEmpty)
            emptyView.addSubview(imageView)

            transactionsTableView.backgroundView = self.emptyView
            self.emptyResults(isHidden: true)
        }
    }

    func emptyResults(isHidden: Bool) {
        let hugoWord = "hugo"
        let payAllString = "¡Págalo todo con hugo!"

        let locString = String(format: "%@ %@", "hp_lbl_home_emptystate_trx".localizedString, "hp_lbl_home_emptystate_payall".localizedString)

        let attributedEmptyString = NSAttributedString.title(
            locString,
            font: UIFont.init(name: Fonts.Book.rawValue, size: 13) ?? UIFont(),
            color: UIColor(red: 42.0 / 255.0, green: 12.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0),
            kern: 0
        )

        let mutableAttribuedEmptyString = NSMutableAttributedString(
            attributedString: attributedEmptyString
        )

        mutableAttribuedEmptyString.bold(
            hugoWord,
            font: UIFont.init(name: Fonts.Bold.rawValue, size: 13) ?? UIFont())

        mutableAttribuedEmptyString.bold(
            payAllString,
            font: UIFont.init(name: Fonts.Bold.rawValue, size: 13) ?? UIFont())

        messageIsEmpty.attributedText = mutableAttribuedEmptyString

        self.transactionsTableView.backgroundView?.isHidden = isHidden
    }
    
    func loadMainInfo() {
        scrollView.delegate = self
        getCCHugoPay()
        getBalanceHPFull()
    }
    
    func initiCashbackView() {
        cashBackView.layer.roundCorners(radius: cashBackView.frame.height/2)
        cashBackView.layer.applySketchShadow(color: UIColor.init(hex: "474a52"), alpha: 0.09, x: 1.0, y: 1.0, blur: 10.0, spread: 0.0)
        
//        let tapCashback = UITapGestureRecognizer(target: self, action: #selector(openCashback))
        self.cashBackView.isUserInteractionEnabled = true
//        self.cashBackView.addGestureRecognizer(tapCashback)
    }
    
    func configurePageControlBars() {
        ccPageControlBars.frame = CGRect(x: 0, y: -10, width: view.bounds.width, height: ccPageControlBarsBox.bounds.height)
        ccPageControlBars.backgroundColor = .clear
        ccPageControlBarsBox.backgroundColor = .clear
        
        ccPageControlBarsBox.addSubview(ccPageControlBars)
    }

    func configureOptionsCollectionView() {
        self.optionsCollectionView.backgroundColor = UIColor.clear

        self.optionsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        optionsCollectionView.register(UINib(nibName: "OptionHPFullCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OptionHPFullCollectionViewCell")

        self.optionsCollectionView.dataSource = self.viewModel
        self.optionsCollectionView.delegate = self.viewModel
    }

    func configureOptionsButtonsBox() {
        optionsButtonsBox.backgroundColor = .clear
    }
    
    func initPageControl() {
        ccPageControlBars.numberOfPages = viewModel.getCCs().count
        ccPageControlBars.assignCurrentPage(index: 0)
        ccPageControlBars.renderPageControlBars()
    }
    
    func renderEmptyStateCards() {
        initPageControl()
        
        if ccScrollViewBox.subviews.count > 0 {
            ccScrollViewBox.subviews.forEach { $0.removeFromSuperview() }
            ccScrollViewBox.setContentOffset(.zero, animated: false)
        }
        
        ccScrollViewBox.frame = CGRect(x: 50, y: 0, width: view.bounds.width - (50 * 2), height: 159)
        ccScrollViewBox.subviews.forEach { $0.removeFromSuperview() }
        ccScrollViewBox.delegate = self
        
        var retainMarginCardBoxX: CGFloat = 0.0
        let numberOfCards: Int = viewModel.getCCs().count
        let userCards = viewModel.getCCs()
        
        if numberOfCards > 0 {
            let cardSelector = CreditCard()
            var cardIndex: Int = 0
            
            for card in userCards {
                let cardBox = UIView(frame: CGRect(x: retainMarginCardBoxX,
                                                   y: 20,
                                                   width: ccScrollViewBox.bounds.width,
                                                   height: ccScrollViewBox.bounds.height))
                cardBox.backgroundColor = .clear
                
                cardBox.tag = cardIndex
                cardIndex += 1
                
                let cardWidth: CGFloat = cardBox.bounds.width - 16
                let cardView = UIView(frame: CGRect(x: (cardBox.bounds.width / 2) - (cardWidth / 2),
                                                    y: 0,
                                                    width: cardWidth,
                                                    height: cardBox.bounds.height))
                
                cardView.backgroundColor = .clear
                retainMarginCardBoxX = cardBox.frame.origin.x + cardBox.bounds.width
                
                // Background
                let cardImageView = UIImageView(frame: cardView.bounds)
                cardImageView.image = #imageLiteral(resourceName: "hp_full_card")
                cardImageView.contentMode = .scaleToFill
                
                // Card Number
                let cardNumberLab = UILabel(frame: CGRect(x: 20, y: 130, width: cardView.bounds.width / 2, height: 24))
                cardNumberLab.font = UIFont.init(name: Fonts.Medium.rawValue, size: 14)
                cardNumberLab.textColor = .getCardTextColor("orange")
                cardNumberLab.text = "**** \(card.cardNumber?.suffix(4) ?? "")"
                
                // Card Logo
                let cardLogoView = UIImageView(frame: CGRect(x: cardView.bounds.width - 67, y: 130, width: 57, height: 18))
                cardLogoView.contentMode = .scaleAspectFit
                
                cardLogoView.image = cardSelector.visaIcon(color: "orange")
                
                // Renders
                cardView.addSubview(cardImageView)
                cardView.addSubview(cardNumberLab)
                cardView.addSubview(cardLogoView)
                cardBox.addSubview(cardView)
                if card.status == "BLOQUEADA" {
                    cardStatus = true
                    switchBlockCCHPFull.image = UIImage(named: "hp_full_switch_lock_card")
                    let blockLogo = UIImageView(frame: CGRect(x: (cardImageView.bounds.width - 96) / 2, y: (cardImageView.bounds.height - 96) / 2, width: 96, height: 96))
                    blockLogo.contentMode = .scaleAspectFit
                    blockLogo.image = UIImage(named: "hp_full_block")
                    cardView.addSubview(blockLogo)
                }else {
                    cardStatus = false
                    switchBlockCCHPFull.image = UIImage(named: "hp_full_switch_card")
                }
                ccScrollViewBox.addSubview(cardBox)
            }
        } else {
            let cardBox = UIView(frame: CGRect(x: retainMarginCardBoxX,
                                               y: 0,
                                               width: ccScrollViewBox.bounds.width,
                                               height: ccScrollViewBox.bounds.height))
            
            let cardWidth: CGFloat = cardBox.bounds.width - 16
            let cardContainer = UIImageView(frame: CGRect(x: (cardBox.bounds.width / 2) - (cardWidth / 2),
                                                          y: 0,
                                                          width: cardWidth,
                                                          height: cardBox.bounds.height))
            cardContainer.image = #imageLiteral(resourceName: "cc_purple")
            
            let addCardButton = UIImageView(frame: CGRect(x: (cardContainer.bounds.width / 2) - (37.0 / 2),
                                                          y: (cardContainer.bounds.height / 2) - (37.0 / 2),
                                                          width: 37.0,
                                                          height: 37.0))
            addCardButton.image = #imageLiteral(resourceName: "ic_add_button_card_hugopay")
            
            let addCardLabel = UILabel(frame: CGRect(x: 0, y: addCardButton.frame.origin.y + addCardButton.bounds.height + 11, width: cardContainer.bounds.width, height: 24))
            addCardLabel.font = UIFont.init(name: Fonts.Medium.rawValue, size: 11)
            addCardLabel.textAlignment = .center
            addCardLabel.textColor = .white
            addCardLabel.text = "hp_lbl_home_addcard".localizedString
            
            cardContainer.addSubview(addCardButton)
            cardContainer.addSubview(addCardLabel)
            cardBox.addSubview(cardContainer)
            ccScrollViewBox.addSubview(cardBox)
            
            ccPageControlBars.numberOfPages = 1
            ccPageControlBars.assignCurrentPage(index: 0)
            ccPageControlBars.renderPageControlBars()
        }
        
        ccScrollViewBox.contentSize = CGSize(width: retainMarginCardBoxX, height: ccScrollViewBox.bounds.height)
        scrollView.addSubview(ccScrollViewBox)
    }

    func updateOptionsButtonsBox() {
        let optionsArray = viewModel.textsHugoPay ?? [HomeHPFullOptions]()
        var optionsArrayFixed = [HomeHPFullOptions]()

        optionsButtonsBox.subviews.forEach { $0.removeFromSuperview() }

        let scrollOptions = UIScrollView(frame: CGRect(x: 0, y: 0, width: optionsButtonsBox.bounds.width, height: optionsButtonsBox.bounds.height))
        scrollOptions.backgroundColor = .clear

        let blockWidth: CGFloat = (scrollOptions.frame.size.width - (16 * 2) - 20) / 3
        var retainMarginXBlocks: CGFloat = 16
        var optionTag: Int = 0

        if let option1 = optionsArray.first(where: {$0.type == "apply_for"}) {
            optionsArrayFixed.append(option1)
        }

        if let option2 = optionsArray.first(where: {$0.type == "cash_in"}) {
            optionsArrayFixed.append(option2)
        }

        if let option3 = optionsArray.first(where: {$0.type == "send"}) {
            optionsArrayFixed.append(option3)
        }

        for option in optionsArrayFixed {
            if option.type == "apply_for" || option.type == "cash_in" || option.type == "send" {
                let optionBlock = UIView(frame: CGRect(x: retainMarginXBlocks, y: (scrollOptions.bounds.height / 2) - (40 / 2), width: blockWidth, height: 40))
                optionBlock.backgroundColor = .white
                optionBlock.layer.cornerRadius = optionBlock.bounds.height / 2
                optionBlock.layer.masksToBounds = true
                optionBlock.layer.applySketchShadow(color: UIColor.init(hex: "474a52"), alpha: 0.1, x: 4.0, y: 3.0, blur: 10.0, spread: 0.0)
                optionBlock.tag = optionTag

                let optionIcon = UIImageView(frame: CGRect(x: 5,
                                                           y: (optionBlock.bounds.height / 2) - (25 / 2),
                                                           width: 25,
                                                           height: 25))

                if let url = URL(string: option.image ?? "") {
                    Nuke.loadImage(with: url, into: optionIcon)
                }

                let optionTitle = UILabel(frame: CGRect(x: optionIcon.frame.origin.x + optionIcon.bounds.width,
                                                        y: 0,
                                                        width: optionBlock.bounds.width - (optionIcon.frame.origin.x + optionIcon.bounds.width + 10),
                                                        height: optionBlock.bounds.height))
                optionTitle.font = UIFont.init(name: Fonts.Book.rawValue, size: 11)
                optionTitle.textColor = .purpleOptionTitle
                optionTitle.textAlignment = .center
                optionTitle.text = option.text ?? ""

                let optionButtonTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnOptionButtonAction(_:)))
                optionButtonTap.view?.tag = optionTag
                optionBlock.addGestureRecognizer(optionButtonTap)

                optionTag += 1
                retainMarginXBlocks = optionBlock.frame.origin.x + optionBlock.bounds.width + 10

                optionBlock.addSubview(optionIcon)
                optionBlock.addSubview(optionTitle)
                scrollOptions.addSubview(optionBlock)
            }
        }

        optionsButtonsBox.addSubview(scrollOptions)
    }
    
    @objc func didTapOnOptionButtonAction(_ sender: UITapGestureRecognizer) {
        guard let sender = sender.view?.tag else { return }
        switch sender {
        case 0:
            openRequestMoney()
        case 1:
            openCashIn()
        case 2:
            openSendMoney()
        default:
            break
        }
    }
    
    func configureCCCollectionView() {
        self.hugoPayFullCreditCards.backgroundColor = UIColor.clear
        
        self.hugoPayFullCreditCards.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        hugoPayFullCreditCards.register(UINib(nibName: "CardHPFullCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardHPFullCollectionViewCell")
        
        self.hugoPayFullCreditCards.dataSource = self.viewModel
        self.hugoPayFullCreditCards.delegate = self.viewModel
    }
    
    func presentSuccesAlert(){
        let alert = UIAlertController(title: "Actualización exitoso", message: "Se realizo la actualización con éxito", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func verifyTutorialStatus() {
        if let readInstructions = viewModel.hugoPayFullData.hugoPayFullInit?.read_instructions {
            if !readInstructions {
                if let vc = R.storyboard.hugoPayFullTutorial.instantiateInitialViewController() {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        } else {
            if let vc = R.storyboard.hugoPayFullTutorial.instantiateInitialViewController() {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
}

// MARK: - ScrollViewDelegate

extension MainHPFullViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex: Int = Int(scrollView.contentOffset.x / scrollView.frame.width);
        
        displayCardIndex = Int(pageIndex)
        ccPageControlBars.assignCurrentPage(index: Int(pageIndex))
    }
    
}

// MARK: - Actions
extension MainHPFullViewController {
    
    @IBAction func actionBlockCCHPFull(_ sender: Any) {
        if cardStatus {
            self.unlockCCHPFull()
        }else {
            self.blockCCHugoPay()
        }
    }
    
    @IBAction func openOptions(_ sender: Any) {
        openOptionsMain(validateTutorial: true)
    }

    @IBAction func openNotifications(_ sender: Any) {
        openNotifications()
    }

    @IBAction func openTransactions(_ sender: Any) {
        openTransactions()
    }

    @IBAction func openMenu(_ sender: Any) {
        if let vc = R.storyboard.hugoPayFull.menuHPFullViewController() {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            print(viewModel.textsHugoPay?[8].items)
            vc.menuTextHPFull = viewModel.textsHugoPay?[8].items ?? [MenuHPFull]()
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - Endpoints

extension MainHPFullViewController {

    func getInitTextHugoPay(){
        showLoading()
        viewModel.getInitHugoPay().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = ccdata.success, success, let _ = ccdata.data {
                        self?.updateOptionsButtonsBox()
                        self?.initiCashbackView()
                        self?.getTransactionsHugoPay()
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
    
    func getCCHugoPay(){
        showLoading()
        viewModel.getCCHugoPay().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = ccdata.success, success, let _ = ccdata.data {
                        self?.renderEmptyStateCards()
                        self?.getConfigHugoPay()
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
    
    func blockCCHugoPay() {
        showLoading()
        viewModel.blockCCHPFull().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let _ = ccdata.success {
                        self?.getCCHugoPay()
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
    
    func unlockCCHPFull() {
        showLoading()
        viewModel.unlockCCHPFull().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let _ = ccdata.success {
                        self?.getCCHugoPay()
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
    
    func getBalanceHPFull() {
        showLoading()
        viewModel.getBalanceHPFull().asObservable()
            .subscribe(onNext: {[weak self] (balance) in
                guard let balance = (balance) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    self?.getCashbackBalance()
                    if let success = balance.success, success, let balanceValue = balance.data?.balance {
                        self?.balanceLbl.text = "\(balanceValue)"
                    } else {
                        if let msg = balance.message {
                            showErrorCustom("Error", msg)
                        } else {
                            showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func getCashbackBalance() {
        showLoading()
        viewModel.getCashbackBalance().asObservable()
            .subscribe(onNext: {[weak self] (balance) in
                guard let balance = (balance) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = balance.success, success, let balanceValue = balance.data?.cashback_label {
                        self?.cashbackLbl.text = "\(balanceValue)"
                    } else {
                        if let msg = balance.message {
                            showErrorCustom("Error", msg)
                        } else {
                            showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getConfigHugoPay(){
        showLoading()
        viewModel.getConfigHugoPay().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = ccdata.success, success, let _ = ccdata.data {
                        self?.hugoPayFullCreditCards.reloadData()
                        self?.getInitTextHugoPay()
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
    
    func doUpdateBiometrics(_ active: Bool){
        showLoading()
        viewModel.updateBiometrics(active).asObservable()
            .subscribe(onNext: {[weak self] (biometricsdata) in
                guard let biometricsdata = biometricsdata else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = biometricsdata.success, success {
                        self?.presentSuccesAlert()
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

    func getTransactionsHugoPay(){
        showLoading()
        viewModel.getTransactionsHugoPay().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = ccdata.success, success, let _ = ccdata.data {
                        if let c = self?.viewModel.getTransaction()?.count, c > 0 {
                            self?.emptyResults(isHidden: true)
                            self?.transactionsTableView.reloadData()
                        } else {
                            self?.emptyResults(isHidden: false)
                            self?.transactionsTableView.reloadData()
                        }
                        self?.getTutorialSteps()
//                        self?.getTutorialTextDataHugoPay()
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

    func getTutorialSteps() {
        showLoading()
        viewModel.getTutorialSteps().asObservable()
            .subscribe(onNext: {[weak self] (steps) in
                guard let balance = (steps) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = steps?.success, success {
                        if !(self?.viewModel.getTutorialOne() ?? true) {
                            self?.showTutorial()
                        }
                    } else {
                        if let msg = balance.message {
                            showErrorCustom("Error", msg)
                        } else {
                            showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func openNotifications() {
        if let vc = R.storyboard.hugoPayFull.notificationsHPFullViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func openTransactions() {
        let vc = TransactionsHPFullViewController.instantiate(fromAppStoryboard: .HugoPayFull)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func showTutorial() {
        if let vc = R.storyboard.tutorialHPFull.instantiateInitialViewController(){
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

    func showConfigurationTutorial() {
        if let vc = R.storyboard.tutorialSettingsHPFull.instantiateInitialViewController() {
            vc.modalPresentationStyle = .overFullScreen
            self.tabBarController?.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - Pullup Views

extension MainHPFullViewController {
    
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
        self.optionsMainView?.removeViews()
        self.optionsSecurityView?.removeViews()
        self.optionsTicketView?.removeViews()
        self.sendMoneyView?.removeViews()
        self.sendMoneyConfirmationView?.removeViews()
        self.requestMoneyView?.removeViews()
        self.requestMoneyConfirmationView?.removeViews()
        self.cashinMoneyIncome?.removeViews()
        self.cashinMoneyConfirmation?.removeViews()
    }

    func openOptionsMain(validateTutorial: Bool) {
        if validateTutorial {
            openOptionsMain { (success) -> Void in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if !self.viewModel.getTutorialTwo() {
                            self.showConfigurationTutorial()
                        }
                    }
                }
            }
        }else {
            openMain()
        }
    }

    func openOptionsMain(completion: (_ success: Bool) -> Void){
        openMain()
        completion(true)
    }

    func openMain() {
        showOverlay()
        pullUpView.setup(with: 230)
        optionsMainView?.prepareViews(pullUpView)
        optionsMainView?.view.layer.roundCorners(radius: 15.0)
        optionsMainView?.configureTexts(viewModel.getConfig())

        optionsMainView?.goCC = {[weak self] in
            //            self?.openCC()
        }
        optionsMainView?.goHelp = {[weak self] in
            self?.openOptionsTicket()
        }
        optionsMainView?.goSecurity = {[weak self] in
            self?.openOptionsSecurity()
        }

        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    func openOptionsSecurity(){
        showOverlay()
        pullUpView.setup(with: 200)
        optionsSecurityView?.prepareViews(pullUpView)
        optionsSecurityView?.view.layer.roundCorners(radius: 15.0)
        optionsSecurityView?.backFromSecurity = {[weak self] in
            self?.backToMainOptions()
        }
        optionsSecurityView?.changeBiometrics = {[weak self] (active) in
            self?.updateBiometrics(active)
        }
        optionsSecurityView?.changePin = {[weak self] in
            self?.openChangePin()
        }
        
        optionsSecurityView?.configureTexts(viewModel.getConfig(), viewModel.getBiometrics())
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    func openChangePin(){
        if let vc = R.storyboard.hugoPayFull.createPinHPFullViewController() {
            vc.modalPresentationStyle = .fullScreen
            vc.fromMain = true
            vc.delegate = delegate
            self.tabBarController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func openOptionsTicket(){
        showOverlay()
        pullUpView.setup(with: 150)
        optionsTicketView?.prepareViews(pullUpView)
        optionsTicketView?.view.layer.roundCorners(radius: 15.0)
        optionsTicketView?.configureTexts(viewModel.getConfig())
        
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
        
        optionsTicketView?.backFromHelp = {[weak self] in
            self?.backToMainOptions()
        }
        
        optionsTicketView?.openFAQ = {[weak self] in
            self?.openFAQWebView()
        }
        
        optionsTicketView?.openTicket = {[weak self] in
            self?.hideOverlay()
            self?.pullUpView.hide(animated: true)
            self?.openCallRequestView()
        }
    }
    
    func openCallRequestView() {
//        if let vc = R.storyboard.hugoPay.troubleShootingHugoPayViewController() {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    func openFAQWebView() {
//        if let vc = R.storyboard.hugoPay.showTermsConditionsViewController() {
//            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            
//            self.present(vc, animated: true, completion: {
//                vc.loadContentWith(url: "https://hugopay.io/#faqs")
//            })
//        }
    }
    
    func openSendMoney() {
        showOverlay()
        pullUpView.setup(with: 411)
        
        sendMoneyView?.prepareViews(pullUpView)
        sendMoneyView?.view.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        sendMoneyView?.contentView?.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        sendMoneyView?.phoneView.getCountryByIp()
                
        sendMoneyView?.sendMoneyConfirmation = { [weak self] recipientType, areaCode, recipient, amount, contact in
            self?.openSendMoneyConfirmation(recipientType: recipientType,
                                            areaCode: areaCode,
                                            recipient: recipient,
                                            amount: amount,
                                            contact: contact ?? nil)
        }
        
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    func openSendMoneyConfirmation(recipientType: RecipientType,
                                   areaCode: String,
                                   recipient: String,
                                   amount: Double,
                                   contact: HugoPayContact?) {
        self.sendMoneyView?.removeViews()
        
        showOverlay()
        pullUpView.setup(with: 450)
        
        sendMoneyConfirmationView?.prepareViews(pullUpView,
                                                recipient: recipient,
                                                areaCode: areaCode,
                                                sendAmount: amount,
                                                recipientType: recipientType,
                                                contact: contact ?? nil)
        sendMoneyConfirmationView?.view.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        sendMoneyConfirmationView?.contentView?.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        
        // Send Money Success
        sendMoneyConfirmationView?.goToSendMoneySuccessViewController = { [weak self] (transferId, successMessage) in
            let vc = SendMoneySuccessViewController.instantiate(fromAppStoryboard: .SendMoney)
            vc.hugoId = transferId
            vc.successMessage = successMessage
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        
        // Send Money Failure
        sendMoneyConfirmationView?.goToSendMoneyFailureViewController = { [weak self] failureMessage, errorCode  in
            let vc = SendMoneyFailureViewController.instantiate(fromAppStoryboard: .SendMoney)
            vc.errorMessage = failureMessage
            vc.errorCode = errorCode
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true) 
        
    }
    
    func openRequestMoney() {
        showOverlay()
        pullUpView.setup(with: 411)
        
        requestMoneyView?.prepareViews(pullUpView)
        requestMoneyView?.view.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        requestMoneyView?.contentView?.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        requestMoneyView?.phoneView.getCountryByIp()
        
        requestMoneyView?.requestMoneyConfirmation = { [weak self] recipientType, areaCode, recipient, amount, contact in
            self?.openRequestMoneyConfirmation(recipientType: recipientType,
                                               areaCode: areaCode,
                                               recipient: recipient,
                                               amount: amount,
                                               contact: contact ?? nil)
        }
        
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    func openRequestMoneyConfirmation(recipientType: RecipientType,
                                      areaCode: String,
                                      recipient: String,
                                      amount: Double,
                                      contact: HugoPayContact?) {
        self.requestMoneyView?.removeViews()
        
        showOverlay()
        pullUpView.setup(with: 450)
        
        requestMoneyConfirmationView?.prepareViews(pullUpView,
                                                   recipient: recipient,
                                                   areaCode: areaCode,
                                                   sendAmount: amount,
                                                   recipientType: recipientType,
                                                   contact: contact ?? nil)
        requestMoneyConfirmationView?.view.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        requestMoneyConfirmationView?.contentView?.layer.roundCorners(radius: HugoPay.UI.pullUpViewCornerRadius)
        
        // Request Money Success
        requestMoneyConfirmationView?.goToSendMoneySuccessViewController = { [weak self] (transferId, successMessage) in
            let vc = RequestMoneySuccessViewController.instantiate(fromAppStoryboard: .RequestMoney)
            vc.hugoId = transferId
            vc.successMessage = successMessage
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        
        // Request Money Failure
        requestMoneyConfirmationView?.goToSendMoneyFailureViewController = { [weak self] failureMessage, errorCode  in
            let vc = SendMoneyFailureViewController.instantiate(fromAppStoryboard: .SendMoney)
            vc.errorMessage = failureMessage
            vc.errorCode = errorCode
            vc.isRequestMoney = true
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    func backToMainOptions() {
        if overlay.superview != nil {
            self.pullUpView.hide(animated: true)
            removeViewsFromPullUp()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.overlay.alpha = 0
            }, completion: { (success) in
                self.overlay.removeFromSuperview()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   self.openOptionsMain(validateTutorial: false)
                }
            })
        }
    }
    
    func updateBiometrics(_ active: Bool){
        if active {
            authenticationWithTouchID()
        } else {
            doUpdateBiometrics(active)
        }
    }
    
    func openCC(){
//        hideOverlay()
//        if let vc = R.storyboard.creditCard.ccRegistrationViewController() {
//                   vc.modalPresentationStyle = .fullScreen
//                   self.present(vc, animated: true, completion: nil)
//        }
    }

    func openCashIn() {
        showOverlay()
        pullUpView.setup(with: 350)
        cashinMoneyIncome?.prepareViews(pullUpView)
        cashinMoneyIncome?.view.layer.roundCorners(radius: 15.0)
        cashinMoneyIncome?.contentView.layer.roundCorners(radius: 15.0)
        
        cashinMoneyIncome?.goCashInMoneyConfirmation = {[weak self] money in
            self?.openCashInMoneyConfirmation(with: money)
        }
        
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    func openCashInMoneyConfirmation(with money: Double?) {
        self.cashinMoneyIncome?.removeViews()
        showOverlay()
        pullUpView.setup(with: 425)
        cashinMoneyConfirmation?.prepareViews(pullUpView, money)
        cashinMoneyConfirmation?.view.layer.roundCorners(radius: 15.0)
        
        cashinMoneyConfirmation?.goCreditCardListViewController = {[weak self] in
//            let vc = CCListViewController()
//            vc.modalPresentationStyle = .fullScreen
//            vc.isHPF = true
//            vc.delegate = self
//            self?.present(vc, animated: true, completion: nil)
        }
        
        cashinMoneyConfirmation?.goSuccessCashinViewController = {[weak self] (hugoId, balance)in
            self?.openCashinSuccessViewController(with: hugoId)
        }
        
        cashinMoneyConfirmation?.goFailureCashinViewController = {[weak self] (message) in
            if let vc = R.storyboard.hugoPayFullCashIn.failureCashinViewController(), let message = message {
                vc.messageFailure = message
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
        
        cashinMoneyConfirmation?.showSimpleAlert = {[weak self] message in
            self?.simpleAlert(title: "hugoPay", message: message)
        }
        
        pullUpView.hide(animated: false)
        pullUpView.show(animated: true)
    }
    
    fileprivate func openCashinSuccessViewController(with hugoId: String?) {
        hideOverlay()
        if let vc = R.storyboard.hugoPayFullCashIn.cashinSucessViewController() {
            vc.modalPresentationStyle = .fullScreen
            vc.hugoId = hugoId ?? ""
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
}

extension MainHPFullViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        //        localAuthenticationContext.localizedFallbackTitle = "Por favor usa tu codigo de HugoPay"
        
        var authorizationError: NSError?
        let reason = "La autenticación es necesaria para entrar"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async() {
                        self.doUpdateBiometrics(true)
                    }
                    
                } else {
                    // Failed to authenticate
                    DispatchQueue.main.async() {
                        self.optionsSecurityView?.biometricSwitch.setOn(false, animated: true)
                    }
                    guard let error = evaluateError else {
                        return
                    }
                    print(error)
                    
                }
            }
        } else {
            DispatchQueue.main.async() {
                self.optionsSecurityView?.biometricSwitch.setOn(false, animated: true)
            }
            guard let error = authorizationError else {
                return
            }
            print(error)
        }
    }
}

extension MainHPFullViewController: SendMoneyDelegate {
    func showSendMoney() {
        openSendMoney()
    }
    
    func showRequestMoney() {
        openRequestMoney()
    }
    
    func dismissP2PView() {
        hideOverlay()
    }
}

//extension MainHPFullViewController: CCListDelegate {
//    func updateDefaultCreditCard() {
//        cashinMoneyConfirmation?.configureCreditCard()
//    }
//
//}


extension MainHPFullViewController: CashinDelegate {
    func dismissCashinProcess() {
        hideOverlay()
    }
}
