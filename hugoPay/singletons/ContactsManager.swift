//
//  ContactsManager.swift
//  Hugo
//
//  Created by Ali Gutierrez on 4/26/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Contacts
import ContactsUI
import Foundation

protocol ContactsDelegate {
    func updateContact(contact: HugoPayContact)
}

class ContactsManager {
    
    static let shared = ContactsManager()
    
    var delegate: ContactsDelegate!
    
    var contacts = [HugoPayContact]()
    var isRequestMoney = false
    
    init() {
    }
    
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
        //vc.updateContact = self.updateContact
        vc.isRequestMoney = self.isRequestMoney
        vc.modalPresentationStyle  = .overCurrentContext
        
        DispatchQueue.main.async {
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
