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
  let user = ""
  var organization : UILabel!
  var orglabel = ""
  
  let settingsVC = SettingsViewController()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Products", style: .plain, target: nil, action: nil)
    print(organization ?? "error: unknown organization")
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
    pushToBase()
    //let alert = SCLAlertView()
    //alert.showSuccess("Thank you for your gift!", subTitle: "")
    
    let performPaymentViewController = PerformPaymentViewController(donationAmount: 10000,
                                                                    settings: self.settingsVC.settings)
    //let navController = UINavigationController(rootViewController: PerformPaymentViewController(donationAmount: Int(textField1.text!)!,settings: self.settingsVC.settings))
    self.present(performPaymentViewController, animated: true, completion: nil)
    

  }
  
  
  
  
  
    
}





