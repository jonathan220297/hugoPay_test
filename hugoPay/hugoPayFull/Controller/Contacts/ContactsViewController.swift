//
//  ContactsViewController.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/28/21.
//

import UIKit

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var contactsLbl: UILabel!
    
    // MARK: - Header Outlets
    
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    
    var updateContact: ((HugoPayContact)->())?
    var isRequestMoney: Bool = false
    
    private var searchTxt: UITextField!
    
    lazy var viewModel: ContactsViewViewModel = {
        ContactsViewViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableview()
        configureViewModel()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.contentView.layer.roundCorners(radius: 20.0)
    }
    
    func setContactsArray(contacts: [HugoPayContact]){
        self.viewModel.contacts = contacts.sorted { $0.firstname < $1.firstname }
    }
    
    private func configureView() {
        if isRequestMoney {
            serviceIcon.image = UIImage(named: "requestMoneyIcon")
            serviceLabel.text = "Enviar Solicitud"
        } else {
            serviceIcon.image = UIImage(named: "sendMoneyIcon")
            serviceLabel.text = "Enviar Dinero"
        }
    }
    
    private func configureTableview() {
        self.tableview.dataSource = self.viewModel
        self.tableview.delegate = self.viewModel
        self.searchBar.delegate = self
        self.tableview.estimatedRowHeight = 70
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.separatorStyle = .none
        self.tableview.tableHeaderView = UIView()
        self.tableview.tableFooterView = UIView()
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.sectionIndexColor = .gray
        self.registerTableViewCells()
    }
    
    private func configureViewModel() {
        viewModel.prepareTableViewIndex()
        let items = viewModel.sectionTitles.compactMap { (title) -> SectionIndexViewItem? in
            let item = SectionIndexViewItemView.init()
            item.title = title
            item.indicator = SectionIndexViewItemIndicator.init(title: title)
            item.titleColor = .lightGray1
            item.titleSelectedColor = .headerPurple
            return item
        }
        self.tableview.sectionIndexView(items: items)
        
        viewModel.selectContact = {[weak self](contact) in
            self?.updateContact?(contact)
        }
        
        viewModel.dismissScreen = {[weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func registerTableViewCells() {
        let contactTableViewCell = UINib(nibName: "ContactTableViewCell",
                                         bundle: nil)
        self.tableview.register(contactTableViewCell,
                                forCellReuseIdentifier: "ContactTableViewCell")
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension ContactsViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.searchTxt) {
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchedContacts = viewModel
            .contacts
            .filter { $0.firstname.lowercased().contains(searchText.lowercased()) ||
                $0.lastname.lowercased().contains(searchText.lowercased()) ||
                $0.phone.lowercased().contains(searchText.lowercased())
            }
        viewModel.isSearching = true
        tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearching = false
        searchBar.text = ""
        tableview.reloadData()
    }
}
