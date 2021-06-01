//
//  ContactsViewViewModel.swift
//  Hugo
//
//  Created by Ali Gutierrez on 3/28/21.
//

import UIKit

class ContactsViewViewModel: NSObject {
    
    var selectContact: ((HugoPayContact)->())?
    var dismissScreen: (()->())?
    
    var contacts = [HugoPayContact]()
    var searchedContacts = [HugoPayContact]()
    var contactsDictionary = [String: [HugoPayContact]]()
    var sectionTitles = [String]()
    var isSearching = false
    
    
    func prepareTableViewIndex() {
        for contact in contacts {
            let contactKey = String(contact.firstname.prefix(1))
            if var contactValues = contactsDictionary[contactKey] {
                contactValues.append(contact)
                contactsDictionary[contactKey] = contactValues
            } else {
                contactsDictionary[contactKey] = [contact]
            }
        }
        sectionTitles = [String](contactsDictionary.keys).sorted(by: { $0 < $1 })
    }
}

extension ContactsViewViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(56)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            self.selectContact?(searchedContacts[indexPath.row])
            self.dismissScreen?()
        } else {
            let contactKey = sectionTitles[indexPath.section]
            if let contactValues = contactsDictionary[contactKey] {
                self.selectContact?(contactValues[indexPath.row])
                self.dismissScreen?()
            }
        }
    }
}

extension ContactsViewViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return ""
        }
        return sectionTitles[section]
    }
    
    //    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        if isSearching {
    //            return [String]()
    //        }
    //        return sectionTitles
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        }
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !contacts.isEmpty {
            let contactNameKey = sectionTitles[section]
            if isSearching {
                return searchedContacts.count
            } else {
                if let contactNameValues = contactsDictionary[contactNameKey] {
                    return contactNameValues.count
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactTableViewCell = tableView.dequeueCell(withIdentifier: "ContactTableViewCell", for: indexPath)
        cell.contactImage.image = nil
        if isSearching {
            cell.nameLbl.text = "\(self.searchedContacts[indexPath.row].firstname) \(self.searchedContacts[indexPath.row].lastname)"
            cell.phoneNumberLbl.text = self.searchedContacts[indexPath.row].phone
            
            if searchedContacts[indexPath.row].imageDataAvailable {
                let image = UIImage(data: searchedContacts[indexPath.row].thumbnailImageData)
                cell.contactImage.image = image
            } else {
                cell.contactImage.setImageForName("\(self.searchedContacts[indexPath.row].firstname) \(self.searchedContacts[indexPath.row].lastname)",
                                                  backgroundColor: UIColor.lightGray,
                                                  circular: true,
                                                  textAttributes: nil)
            }
            
        } else {
            let contactKey = sectionTitles[indexPath.section]
            if let contactValues = contactsDictionary[contactKey] {
                let firstname = contactValues[indexPath.row].firstname
                let lastname = contactValues[indexPath.row].lastname
                let phone = contactValues[indexPath.row].phone
                cell.nameLbl.text = "\(firstname) \(lastname)"
                cell.phoneNumberLbl.text = phone
                if contactValues[indexPath.row].imageDataAvailable {
                    let image = UIImage(data: contactValues[indexPath.row].thumbnailImageData)
                    cell.contactImage.image = image
                } else {
                    cell.contactImage.setImageForName("\(firstname) \(lastname)",
                                                      backgroundColor: UIColor.lightGray,
                                                      circular: true,
                                                      textAttributes: nil)
                }
                
            }
            
        }
        
        return cell
    }
}

