//
//  HugoPayPhoneView.swift
//  hugo
//
//  Created by Ali Gutierrez on 3/27/21.
//

import Contacts
import Nuke
import RxCocoa
import SimpleAlert
import UIKit

class HugoPayPhoneView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectedContactView: UIView!
    @IBOutlet weak var countryFlagImg: UIImageView!
    @IBOutlet weak var selectedContactImageView: UIImageView!
    @IBOutlet weak var selectedContactName: UILabel!
    @IBOutlet weak var selectedContactPhoneNumber: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var selectCountryArrow: UIImageView!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet var view: UIView!
    
    var hasLength = false
    var hasSelectCountry = false
    var isRequestMoney = false
    var hasSelectContact = BehaviorRelay<Bool>(value: false)
    var textFieldLength: Int?
    var maxTextFieldLength: Int?
    var minTextFieldLength: Int?
    var userManager = UserManager.shared
    var registrationService = RegistrationService()
    
    var selectedContact: HugoPayContact?
    var countryCodes: [CountryCodeItem]?
    var selectedCountry: CountryCodeItem?
    var contacts = [HugoPayContact]()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    private let apiClient: APIClient = APIClient()
    
    var showAlert: ((AlertController)->())?
    var showUIAlert: ((UIAlertController)->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    var removeObservers: (()->())?
    var addObservers: (()->())?
    var presentVC: ((UIViewController)->())?
    
    @IBAction func didTapDeselectButton(_ sender: Any) {
        deselectContact()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareView()
    }
    
    func prepareView(){
        let nib = Bundle.main.loadNibNamed("HugoPayPhoneView", owner: self, options: nil)
        if let view = nib?.first as? UIView {
            addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = true
            view.frame.size.width = view.superview?.frame.size.width ?? 0.0

            countryCodeLbl.adjustsFontSizeToFitWidth = true
            
            phoneTxt.delegate = self
            phoneTxt.placeholder = "Número telefónico"
            phoneTxt.keyboardType = .phonePad
            
            selectedContactImageView.layer.cornerRadius = selectedContactImageView.frame.height/2
            selectedContactImageView.clipsToBounds = true
            selectedContactImageView.layer.masksToBounds = true
            
            selectedContactView.isHidden = true
            selectedContactView.layer.addShadow()
            
            backgroundView.layer.addShadow()
            backgroundView.layer.roundCorners(radius: backgroundView.frame.size.height/2)
        }
    }
    
    @objc func changeCode() {
        self.goToCuntryCodes()
    }
    
    func goToCuntryCodes(){
//        if let codes = self.countryCodes {
//            let vc = CountryCodesViewController()
//            vc.view.makeCorner(withRadius: 15)
//            vc.setCountryCodesArray(countries: codes)
//            vc.updateCountry = self.updateCountry
//            let currentController = self.getCurrentViewController()
//            currentController?.present(vc, animated: false, completion: nil)
//        }
    }
    
    func getCountryByIp() {
        if !hasSelectCountry{
            self.showLoading?()
//            defaultCountry { (country) in
//                if let country = country {
//                    self.loadCountryCodes(country)
//                }
//                else {
//                    self.loadCountryCodes("SV")
//                }
//            }
        }
    }
    
    func loadCountryCodes(_ code : String){
        self.registrationService.getCountryCodes { (countryCodeList) in
            if let countryCodeList = countryCodeList {
                self.countryCodes = countryCodeList
                self.apiClient.send(DoDefaultAddress(
                    profile_id: self.userManager.profile_id ?? ""
                )) { response in
                    DispatchQueue.main.async {
                        switch response {
                        case .success(let response):
                            let country_code = response.data?.country ?? code
                            self.findCountry(with: country_code)
                        case .failure(let error):
                            self.findCountry(with: code)
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                self.hideLoading?()
                self.cannotLoadCountryCodes()
            }
        }
    }
    
    private func findCountry(with code: String) {
        guard
            let countryList = countryCodes,
            let country = countryList.first(where: { $0.code == code }) else {
            cannotLoadCountryCodes()
            self.hideLoading?()
            return
        }
        self.hideLoading?()
        updateCountry(country: country)
    }
    
    func isValidPhone() -> Bool {
        guard let phone = self.phoneTxt.text,
              let country_code = self.countryCodeLbl.text,
              !phone.isEmpty else {
            self.showMessagePrompt(AlertString.PhoneVerification.cannotGetPhoneMessage)
            return false
        }
        
        if phone.containsWhitespace {
            self.showMessagePrompt(AlertString.PhoneVerification.cannotHaveBlankSpacesMessage)
            return false
        }
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let isValid = phone.rangeOfCharacter(from: invalidCharacters, options: [], range: phone.startIndex ..< phone.endIndex) == nil
        if !isValid {
            self.showMessagePrompt(AlertString.PhoneVerification.cannotHaveLetttersMessage)
            return false
        }
        
        guard let length = self.textFieldLength else {
            showGeneralError(ErrorCodes.VerifyPhone.EmptyPhoneLength)
            return false
        }
        
        if phone.count != length, hasLength{
            let message = AlertString.PhoneVerification.cannotHaveMoreOrLessCharactersMessage.replace(target: "$1", withString: "\(length)")
            self.showMessagePrompt(message)
            return false
        }
        
        if phone.contains(find: country_code) {
            self.showMessagePrompt(AlertString.PhoneVerification.cannotHaveCountryCodeInPhoneMessage)
            return false
        }
        
        return true
    }
    
    
    func updateCountry(country: CountryCodeItem){
        self.selectedCountry = country
        self.phoneTxt.text = ""
        self.minTextFieldLength = country.min_length
        self.maxTextFieldLength = country.max_length
        self.textFieldLength = 15
        self.hasLength = false
        if let len = country.phone_length
        {
            self.textFieldLength = len
            self.hasLength = true
        }
        self.countryCodeLbl.text = country.area_code
        if let url =  URL(string: country.flag_img ?? ""){
            Nuke.loadImage(with:url, into: countryFlagImg)
        } else {
            countryFlagImg.image = #imageLiteral(resourceName: "hugologoword")
        }
        hasSelectCountry = true
    }
    
    func updateContact(contact: HugoPayContact) {
        self.selectedContact = contact
        showSelectedContactView(contact: contact)
        hasSelectContact.accept(true)
        self.addObservers?()
    }
    
    func showSelectedContactView(contact: HugoPayContact) {
        self.phoneTxt.text = contact.phone
        self.phoneTxt.sendActions(for: .valueChanged)
        self.view.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.frame.width,
                                 height: 80)
        
        
        self.backgroundView.isHidden = true
        self.selectedContactView.isHidden = false
        
        if contact.imageDataAvailable {
            let image = UIImage(data: contact.thumbnailImageData)
            self.selectedContactImageView.image = image
        } else {
            self.selectedContactImageView.setImageForName("\(contact.firstname) \(contact.lastname)",
                                                          backgroundColor: UIColor.lightGray,
                                                          circular: true,
                                                          textAttributes: nil)
        }
        
        self.selectedContactName.text = "\(contact.firstname) \(contact.lastname)"
        self.selectedContactPhoneNumber.text = getPhoneNumber()
        
    }
    
    func deselectContact() {
        self.phoneTxt.text = ""
        self.phoneTxt.sendActions(for: .valueChanged)
        self.view.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.frame.width,
                                 height: 44)
        
        self.hasSelectContact.accept(false)
        self.selectedContactView.isHidden = true
        self.backgroundView.isHidden = false
        
    }
    
    func presentAlertOfCountries(){
        let alert = UIAlertController(title: "Selecciona tu país", message: nil, preferredStyle: .actionSheet)
        
        if let codes = self.countryCodes {
            
            self.phoneTxt.text = ""
            for code in codes {
                alert.addAction(UIAlertAction(title: code.name, style: .default, handler: { (action) in
                    self.updateCountry(country: code)
                }))
            }
        }
        self.showUIAlert?(alert)
    }
    
    func getPhoneNumber() -> String{
        if phoneTxt.text!.contains(find: "+") {
            return phoneTxt.text ?? ""
        }
        return "\(selectedCountry?.area_code ?? "") \(phoneTxt.text ?? "")"
        
    }
    
    func cannotLoadCountryCodes(){
        self.showMessagePrompt("Lo sentimos algo ha salido mal.")
    }
    
    func showMessagePrompt(_ error: String) {
        let alert = AlertController(title: "AProblemOcurredTitle".localizedString, message: error, style: .alert)
        alert.addAction(AlertAction(title: AlertString.OK, style: .default))
        self.showAlert?(alert)
    }
    
    @IBAction func didTapContactsButton(_ sender: Any) {
        self.removeObservers?()
        fetchContacts()
    }
    
    private func fetchContacts() {
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
        DispatchQueue.main.async {
            let vc = ContactsViewController.instantiate(fromAppStoryboard: .SendMoney)
            vc.setContactsArray(contacts: self.contacts)
            vc.updateContact = self.updateContact
            vc.isRequestMoney = self.isRequestMoney
            vc.modalPresentationStyle  = .overCurrentContext
            let currentController = self.getCurrentViewController()
            currentController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            
            return currentController
        }
        
        return nil
    }
}

// MARK: - UITextViewDelegate
extension HugoPayPhoneView: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let length = self.textFieldLength, let phone = textField.text else {
            return false
        }
        
        let characterLimit = length + 1
        let newText = NSString(string: phone).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        if numberOfChars == characterLimit
        {
            textField.resignFirstResponder()
        }
        
        return numberOfChars < characterLimit
    }
}
