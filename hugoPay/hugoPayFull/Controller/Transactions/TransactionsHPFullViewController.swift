//
//  TransactionsHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class TransactionsHPFullViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var transactionsBox: UIView!
    @IBOutlet weak var requestBox: UIView!
    
    @IBOutlet weak var transactionesTableView: UITableView!
    @IBOutlet weak var transactionsTableHeight: NSLayoutConstraint!
    
    // Request
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var requestLabel: UILabel!
    
    // Transactions
    @IBOutlet weak var transactionsImage: UIImageView!
    @IBOutlet weak var transactionsLabel: UILabel!
    
    private var emptyView: UIView!
    private var messageIsEmpty: UILabel!
    private var messageIsEmpty2: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var showRequest = false
    var showingSection = false
    
    lazy var viewModel: TransactionsHPFullViewModel = {
        let vm = TransactionsHPFullViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationViews()
        configureTableView()
        configViewModel()
        configTransactionsBox()
        configRequestBox()
        selectedOption()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transactionesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if viewModel.hugoPayData.withHugoPayFullFilters {
            self.getFilteredTransactionsHugoPayFull()
        } else {
            self.getTransactionsHugoPay(with: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transactionesTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // MARK: - Observers
    @objc func selectOption() {
        showRequest = !showRequest
        selectedOption()
    }
    
    // MARK: - Actions
    @IBAction func goback(_ sender: Any) {
        if showingSection {
            getTransactionsHugoPay(with: nil)
        } else if viewModel.hugoPayData.withHugoPayFullFilters {
            viewModel.hugoPayData.resetFPFFilters()
            getTransactionsHugoPay(with: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonFilterTapped(_ sender: Any) {
        if let vc = R.storyboard.transactions.transactionFiltersViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Functions
    fileprivate func configurationViews() {
        viewBanner.addBottomRoundedEdge()
    }
    
    func configViewModel(){
        viewModel.hugoPayData.resetFPFFilters()
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
        viewModel.emptyResult = { [weak self] (hidden) in
            self?.emptyResults(isHidden: hidden)
        }
        viewModel.showHPFullTransaction = { [weak self] (vc) in
            self?.showHPFullTransaction(vc: vc)
        }
    }
    
    func showHPFullTransaction(vc: UIViewController) {
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func selectedOption() {
        if showRequest {
            requestImage.image = UIImage(named: "hp_full_circle_dollar_enabled")
            transactionsImage.image = UIImage(named: "hp_full_circle_transfer_disabled")
            requestLabel.textColor = UIColor(hexString: "2e1048")
            transactionsLabel.textColor = UIColor(hexString: "80788c")
            self.getRequestHPFull()
        } else {
            requestImage.image = UIImage(named: "hp_full_circle_dollar_disabled")
            transactionsImage.image = UIImage(named: "hp_full_circle_transfer_enabled")
            transactionsLabel.textColor = UIColor(hexString: "2e1048")
            requestLabel.textColor = UIColor(hexString: "80788c")
            if viewModel.hugoPayData.withHugoPayFullFilters {
                self.getFilteredTransactionsHugoPayFull()
            } else {
                self.getTransactionsHugoPay(with: nil)
            }
        }
    }
    
    func emptyResults(isHidden: Bool) {
        let hugoWord = "hugo"
        var titleString = ""
        if viewModel.hugoPayData.withHugoPayFullFilters {
            titleString = "hp_full_TransactionHPFullViewController_EmptyTextFilter".localized
        } else {
            titleString = "hp_full_TransactionHPFullViewController_EmptyText".localized
        }
        let attributedString = NSMutableAttributedString(string: titleString,
                                                         attributes: [
                                                            .font: UIFont(name: "GothamHTF-Medium", size: 16.0)!,
                                                            .foregroundColor: UIColor.purpleTitle,
                                                            .kern: 0.0
                                                         ])
        
        messageIsEmpty.attributedText = attributedString
        
        
        if !viewModel.hugoPayData.withHugoPayFullFilters {
            let locString = String(format: "%@", "hp_full_TransactionHPFullViewController_EmptySubtitle".localizedString)
            
            let attributedEmptyString = NSAttributedString.title(
                locString,
                font: UIFont.init(name: Fonts.Book.rawValue, size: 13) ?? UIFont(),
                color: UIColor.purpleTitle,
                kern: 0
            )
            
            let mutableAttribuedEmptyString = NSMutableAttributedString(
                attributedString: attributedEmptyString
            )
            
            mutableAttribuedEmptyString.bold(
                hugoWord,
                font: UIFont.init(name: Fonts.Bold.rawValue, size: 13) ?? UIFont())
            
            messageIsEmpty2.attributedText = mutableAttribuedEmptyString
        } else {
            messageIsEmpty2.text = ""
        }
        
        self.transactionesTableView.backgroundView?.isHidden = isHidden
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                if newSize.height == 0.0 {
                    self.transactionsTableHeight.constant = 450
                }else {
                    if newSize.height < 450 {
                        self.transactionsTableHeight.constant = 450
                    } else {
                        self.transactionsTableHeight.constant = newSize.height
                    }
                }
            }
        }
    }
    
    func configureTableView() {
        self.transactionesTableView.backgroundColor = UIColor.clear
        
        self.transactionesTableView.tableHeaderView = UIView()
        self.transactionesTableView.tableFooterView = UIView()
        self.transactionesTableView.backgroundView = self.emptyView
        
        self.transactionesTableView.estimatedRowHeight = 60
        self.transactionesTableView.separatorStyle = .none
        self.transactionesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        self.transactionesTableView.register(UINib(nibName: "TransactionHPFullCell", bundle: nil) , forCellReuseIdentifier: "TransactionHPFullCell")
        self.transactionesTableView.register(UINib(nibName: "TransactionFooterTableViewCell", bundle: nil) , forCellReuseIdentifier: "cellTransactionFooter")
        
        self.transactionesTableView.dataSource = self.viewModel
        self.transactionesTableView.delegate = self.viewModel
        
        self.drawIsEmptyView()
    }
    
    func drawIsEmptyView()
    {
        if let table = transactionesTableView {
            let screenSize = UIScreen.main.bounds
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height:  table.frame.size.height))
            
            let messageImageView = UIImageView(image: #imageLiteral(resourceName: "empty_state_alltrx_hugopay"))
            messageIsEmpty = UILabel()
            messageIsEmpty2 = UILabel()
            
            messageImageView.backgroundColor = .clear
            
            messageIsEmpty.translatesAutoresizingMaskIntoConstraints = false
            messageImageView.translatesAutoresizingMaskIntoConstraints = false
            messageIsEmpty2.translatesAutoresizingMaskIntoConstraints = false
            
            emptyView.addSubview(messageIsEmpty)
            emptyView.addSubview(messageImageView)
            emptyView.addSubview(messageIsEmpty2)
            
            messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -70).isActive = true
            messageImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            messageImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            messageIsEmpty.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
            messageIsEmpty.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            messageIsEmpty.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 9/10).isActive = true
            
            messageIsEmpty2.topAnchor.constraint(equalTo: messageIsEmpty.bottomAnchor, constant: 10).isActive = true
            messageIsEmpty2.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            
            messageIsEmpty.numberOfLines = 0
            messageIsEmpty.textAlignment = .center
            messageIsEmpty2.numberOfLines = 0
            messageIsEmpty2.textAlignment = .center
            
            self.transactionesTableView.backgroundView = emptyView
            self.emptyResults(isHidden: true)
        }
    }
    
    func getTransactionsHugoPay(with transactionViewMore: TransactionViewMore?){
        showLoading()
        var today: Bool?
        var month: Bool?
        var previous: Bool?
        switch transactionViewMore {
        case .today:
            today = true
            showingSection = true
            break
        case .month:
            month = true
            showingSection = true
            break
        case .previous:
            previous = true
            showingSection = true
            break
        case .none:
            showingSection = false
            break
        }
        viewModel.getTransactionsHugoPay(with: today, month, previous: previous).asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = ccdata.success, success, let _ = ccdata.data {
                        if let c = self?.viewModel.getTransactions().count, c > 0{
                            self?.emptyResults(isHidden: true)
                            self?.transactionesTableView.reloadData()
                        } else {
                            self?.emptyResults(isHidden: false)
                            self?.transactionesTableView.reloadData()
                        }
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
    
    func getFilteredTransactionsHugoPayFull() {
        showLoading()
        viewModel.getFilteredTransactionsHugoPay().asObservable()
            .subscribe(onNext: {[weak self] (response) in
                DispatchQueue.main.async {
                    self?.hideLoading()
                    guard let response = response else { return }
                    if let success = response.success, success, let _ = response.data {
                        if let c = self?.viewModel.getTransactions().count, c > 0{
                            self?.emptyResults(isHidden: true)
                            self?.transactionesTableView.reloadData()
                        } else {
                            self?.emptyResults(isHidden: false)
                            self?.transactionesTableView.reloadData()
                        }
                    } else {
                        if let msg = response.message {
                            showErrorCustom("Error", msg)
                        } else {
                            showGeneralErrorCustom(ErrorCodes.HugoPay.Login.RegisterPinFail)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getRequestHPFull(){
        showLoading()
        viewModel.getRequestHP().asObservable()
            .subscribe(onNext: {[weak self] (ccdata) in
                guard let ccdata = (ccdata) else { return }
                DispatchQueue.main.async {
                    self?.hideLoading()
                    if let success = ccdata.success, success, let _ = ccdata.data {
                        if let c = self?.viewModel.getTransactions().count, c > 0{
                            self?.emptyResults(isHidden: true)
                            self?.transactionesTableView.reloadData()
                        } else {
                            self?.emptyResults(isHidden: false)
                            self?.transactionesTableView.reloadData()
                        }
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
    
    func configTransactionsBox() {
        transactionsBox.layer.roundCorners(radius: transactionsBox.frame.height/2)
        transactionsBox.layer.applySketchShadow(color: UIColor.init(hex: "474a52"), alpha: 0.09, x: 3.0, y: 4.0, blur: 10.0, spread: 3.0)
        let tapBox = UITapGestureRecognizer(target: self, action: #selector(selectOption))
        self.transactionsBox.isUserInteractionEnabled = true
        self.transactionsBox.addGestureRecognizer(tapBox)
    }
    
    func configRequestBox() {
        requestBox.layer.roundCorners(radius: requestBox.frame.height/2)
        requestBox.layer.applySketchShadow(color: UIColor.init(hex: "474a52"), alpha: 0.09, x: 3.0, y: 4.0, blur: 10.0, spread: 3.0)
        let tapBox = UITapGestureRecognizer(target: self, action: #selector(selectOption))
        self.requestBox.isUserInteractionEnabled = true
        self.requestBox.addGestureRecognizer(tapBox)
    }
}

extension TransactionsHPFullViewController: TransactionsHPFullDelegate {
    func reloadTransactionData(with transactionViewMore: TransactionViewMore?) {
        getTransactionsHugoPay(with: transactionViewMore)
    }
}
