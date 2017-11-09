//
//  SubmitMoney.swift
//  SeniorProject
//
//  Created by Jacari Boboye on 4/21/17.
//  Copyright © 2017 blah. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI
import SCLAlertView


class SubmitMoney: UIViewController{
  
  @IBOutlet var textField1: UITextField!
  @IBOutlet weak var specialnoteView: UITextView!
  
  let user = ""
  var organization : UILabel!
  var orglabel = ""
  var specialnoteViewTapped = false
  
  let settingsVC = SettingsViewController()  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(organization ?? "error: unknown organization")
    textField1.becomeFirstResponder()
    self.hideKeyboardWhenTappedAround()
  }
  
  @IBAction func onTextViewTap(_ sender: UITapGestureRecognizer) {
    if !specialnoteViewTapped {
      specialnoteView.becomeFirstResponder()
      specialnoteView.text = ""
      specialnoteView.textColor = UIColor.black
      specialnoteViewTapped = true
    } else if specialnoteView.text == "" {
      specialnoteView.text = "Write a special message ..."
      specialnoteView.textColor = UIColor.darkGray
    }
  }
  
  @IBAction func backBTN(_ sender: Any) {
    //performSegue(withIdentifier: "BackHome", sender: self)
    
  }
  
  func pushToBase(){
    let gameTable : [String : AnyObject] = ["DollarAmount": textField1.text as AnyObject, "User": user as AnyObject, "Organization": orglabel as AnyObject]
    let databaseRef = FIRDatabase.database().reference()
    let ref = databaseRef.child("MostRecent").childByAutoId()
    ref.setValue(gameTable)
    
  }
  
  @IBAction func subBTN(_ sender: Any) {
    if (textField1.text?.isEmpty)! || (!(textField1.text?.isValidCurrency)!) {
      let alert = UIAlertController(title: "Sorry!", message: "Valid dollar amount is required", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in})
      
      alert.addAction(okAction)
      self.present(alert, animated: true, completion: nil)
      
    } else {
      pushToBase()
      // Present payment confirmation
      let navController = UINavigationController(rootViewController: PerformPaymentViewController(
                                                    donationAmount: Int(textField1.text!)!*100,
                                                    org: orglabel,
                                                    settings: self.settingsVC.settings)
                                                    )
      self.present(navController, animated: true, completion: nil)
    }
  }
  
}

extension String {
  var isValidCurrency: Bool {
    guard self.characters.count > 0 else { return false }
    let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    return Set(self.characters).isSubset(of: nums)
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}




