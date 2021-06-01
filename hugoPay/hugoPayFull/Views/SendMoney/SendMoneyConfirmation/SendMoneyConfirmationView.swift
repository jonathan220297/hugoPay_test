//
//  SendMoneyConfirmationView.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/26/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Contacts
import UIKit
import RxSwift

class SendMoneyConfirmationView: UIView {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var recipientField: UITextField!
    
    @IBOutlet weak var amountToSendLabel: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var additionalNoteTextView: UITextView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var sendButton: TransitionButton!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    
    var view: UIView!
    var pullUpView: PullUpView!
    var recipientType: RecipientType!
    var amountTextfield: UITextField?
    var contacts = [HugoPayContact]()
    var userManager = UserManager.shared
    var areaCode = ""
    
    var goToSendMoneySuccessViewController: ((_ hugoId: String?, _ successMessage: String?)->())?
    var goToSendMoneyFailureViewController: ((_ failureMessage: String?, _ erroCode: Int?)->())?
    
    lazy var viewModel: SendMoneyConfirmationViewModel = {
        return SendMoneyConfirmationViewModel()
    }()
    
    let disposeBag = DisposeBag()
    let generator = UINotificationFeedbackGenerator()
    
    func removeViews() {
        guard let view = self.view else { return }
        view.removeFromSuperview()
    }
    
    func prepareViews(_ vc_view: PullUpView,
                      recipient: String,
                      areaCode: String,
                      sendAmount: Double,
                      recipientType: RecipientType,
                      contact: HugoPayContact?)  {
        let nib = Bundle.main.loadNibNamed("SendMoneyConfirmationView", owner: self, options: nil)
        
        if let view = nib?.first as? UIView {
            pullUpView = vc_view
            vc_view.addSubview(view)
            let newHeight = vc_view.frame.height
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            let amountLblTap = UITapGestureRecognizer(target: self, action: #selector(didTapAmountLbl))
            amountLblTap.numberOfTapsRequired = 1
            self.amountLbl?.addGestureRecognizer(amountLblTap)
            self.amountLbl?.isUserInteractionEnabled = true

            self.recipientField.text = recipient
            self.areaCode = areaCode
            
            self.recipientType = recipientType
            self.amountLbl.text = viewModel.configureAmountLabel(with: sendAmount)
            self.totalLabel.text = self.amountLbl.text
            
            configureAdditionalNoteTextView()
            configureBtn()
            configureKeyboardType(for: recipientType)
            configureContactView(for: contact)
            
            //Notifications
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillShow),
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillHide),
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
            
            view.frame = CGRect(x: 0, y: 0, width: vc_view.frame.width, height: newHeight)
            view.backgroundColor = .clear
            
            self.view = view
        }
    }
    
    func configureAdditionalNoteTextView() {
        self.additionalNoteTextView.textContainerInset = UIEdgeInsets(top: 15,
                                                                      left: 15,
                                                                      bottom: 15,
                                                                      right: 15)
        self.additionalNoteTextView.layer.borderWidth = 1.0
        self.additionalNoteTextView.layer.borderColor = UIColor.lightGray2.cgColor
        self.additionalNoteTextView.layer.cornerRadius = 15
        self.additionalNoteTextView.clipsToBounds = true
        self.additionalNoteTextView.isHidden = true
    }
    
    func configureBtn() {
        addNoteButton.backgroundColor = .clear
        addNoteButton.layer.cornerRadius = 22.0
        addNoteButton.layer.borderWidth = 1.0
        addNoteButton.layer.borderColor = UIColor.lightGray2.cgColor
    }
    
    func configureContactView(for contact: HugoPayContact?) {
        addObservers()
        guard let contact = contact else { return }
        contactView.isHidden = false
        recipientField.isHidden = true
        contactView.layer.addShadow()
        
        contactName.text = "\(contact.firstname) \(contact.lastname)"
        contactPhone.text = contact.phone
        if contact.imageDataAvailable {
            let image = UIImage(data: contact.thumbnailImageData)
            self.contactImage.image = image
        } else {
            self.contactImage.setImageForName("\(contact.firstname) \(contact.lastname)",
                                                          backgroundColor: UIColor.lightGray,
                                                          circular: true,
                                                          textAttributes: nil)
        }
    }
    
    func configureKeyboardType(for recipientType: RecipientType) {
        switch recipientType {
        case .email:
            recipientField.keyboardType = .emailAddress
        case .phone:
            recipientField.keyboardType = .phonePad
        default:
            recipientField.keyboardType = .default
        }
    }
    
    func doSendMoney() {
        self.sendButton.startAnimation()
        self.amountTextfield?.resignFirstResponder()
        self.view.isUserInteractionEnabled = false


        guard let sendAmount = self.amountLbl.text?.removeFormatAmount(),
              let recipient = self.recipientField.text else { return }
        let sendAmountAsDouble = Double(sendAmount)
        let note = self.additionalNoteTextView.text ?? ""

        if viewModel.updateRecipientType(for: recipient) == .undetermined || sendAmountAsDouble <= 0.00 {
            self.recipientField.shake()
            generator.notificationOccurred(.error)
            self.sendButton.stopAnimation()
            self.view.isUserInteractionEnabled = true
        } else {
            self.viewModel
                .doSendMoney(recipientType:viewModel.updateRecipientType(for: recipient),
                                       recipient: recipient,
                                       amount: sendAmountAsDouble,
                                       note: note)
                .asObservable()
                .subscribe(onNext: { [weak self] result in
                    guard let result = (result),
                          let self = self else { return }
                    defer { self.sendButton.stopAnimation() }
                    self.removeObservers()
                    if let success = result.success, success {
                        self.generator.notificationOccurred(.success)
                        self.goToSendMoneySuccessViewController?(result.data?.transactionId, result.message)
                    } else {
                        self.generator.notificationOccurred(.error)
                        self.goToSendMoneyFailureViewController?(result.message, result.code )
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }

    func doAddNote() {
        self.addNoteButton.isHidden = true
        self.additionalNoteTextView.isHidden = false
        self.recipientField.resignFirstResponder()
        self.amountTextfield?.resignFirstResponder()
        self.additionalNoteTextView.becomeFirstResponder()
    }
    
    
    // MARK: - Observers
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        if let viewWithTag = self.view.viewWithTag(99999) {
            viewWithTag.endEditing(true)
            viewWithTag.removeFromSuperview()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder
                                                        .keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.pullUpView.updateHeight(with: 450 + keyboardSize.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.pullUpView.updateHeight(with: 450)
    }
    
    @objc func didTapAmountLbl() {
        amountTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        amountTextfield?.viewWithTag(9999999)
        guard let textfield = amountTextfield else { return }
        self.view.addSubview(textfield)
        textfield.addTarget(self, action: #selector(textFieldMoneyDidChange), for: .editingChanged)
        textfield.keyboardType = .numberPad
        textfield.becomeFirstResponder()
        textfield.text = amountLbl.text?.replacingOccurrences(of: "$", with: "")
    }
    
    @objc func textFieldMoneyDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = amountLbl
                .text?
                .replacingOccurrences(of: viewModel.userManager.symbol ?? "$",
                                      with: "")
            
        } else if textField.text! == "0.00" {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = "0.00"
            totalLabel.text = (viewModel.userManager.symbol ?? "$") + "0.00"
        } else if textField.text! == "0.0" || textField.text! == "0." {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = "0.00"
            totalLabel.text = (viewModel.userManager.symbol ?? "$") + "0.00"
        } else if textField.text! == "0.000" || textField.text! == "0.0000" {
            amountLbl.textColor = .headlineGray
            amountLbl.text = (viewModel.userManager.symbol ?? "$") + "0.00"
            amountTextfield?.text = "0.00"
        } else if let amountString = textField
                    .text?
                    .currencyInputFormatting(with: viewModel.userManager.symbol ?? "$") {
            amountLbl.textColor = .headerPurple
            amountLbl.text = amountString
            totalLabel.text = amountString
        }
    }
    
    // TODO: - Remove
    func fetchContacts() {
        if !contacts.isEmpty {
            self.goToContactsViewController()
        } else {
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (granted, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if granted {
                    self.contacts.removeAll()
                    let keys = [CNContactGivenNameKey,
                                CNContactFamilyNameKey,
                                CNContactPhoneNumbersKey,
                                CNContactImageDataAvailableKey,
                                CNContactThumbnailImageDataKey]
                    let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                    do {
                        try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                            if  let phoneNumber = contact
                                    .phoneNumbers
                                    .first?
                                    .value
                                    .stringValue
                                    .replacingOccurrences(of: "-", with: "")
                                    .replacingOccurrences(of: " ", with: "")
                                    .trimmingCharacters(in: .whitespacesAndNewlines) {
                                self.contacts.append(HugoPayContact(firstname: contact.givenName,
                                                                    lastname: contact.familyName,
                                                                    phone: phoneNumber,
                                                                    imageDataAvailable: contact.imageDataAvailable,
                                                                    thumbnailImageData: contact.thumbnailImageData ?? Data()))
                            }
                        })
                        self.goToContactsViewController()
                    } catch let error {
                        print("Failed to enumerate contact", error)
                    }
                } else {
                    print("access denied")
                }
            }
        }
    }
    
    private func goToContactsViewController() {
        let vc = ContactsViewController.instantiate(fromAppStoryboard: .SendMoney)
        vc.setContactsArray(contacts: contacts)
        vc.updateContact = self.updateContact
        vc.modalPresentationStyle  = .overCurrentContext
        
        DispatchQueue.main.async {
            let currentController = self.getCurrentViewController()
            currentController?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func updateContact(contact: HugoPayContact) {
        configureContactView(for: contact)
        if contact.phone.contains(find: "+") {
            self.recipientField.text = contact.phone
        } else {
            self.recipientField.text = ("\(areaCode) \(contact.phone)")
        }
        
    }
    
    private func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            
            return currentController
        }
        
        return nil
    }
    
    func removeObservers() {
        view.endEditing(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSendButton(_ sender: Any) {
        self.doSendMoney()
    }
    
    @IBAction func didTapAddNoteButton(_ sender: Any) {
        doAddNote()
    }
    
    @IBAction func didTapUpdateContactButton(_ sender: Any) {
        removeObservers()
        fetchContacts()
    }
}
