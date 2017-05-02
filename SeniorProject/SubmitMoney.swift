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
    let organization = ""
    
    override func viewDidLoad() {
        
    }
    
    
    @IBAction func backBTN(_ sender: Any) {
        //performSegue(withIdentifier: "BackHome", sender: self)

    }
    func pushToBase(){
            let gameTable : [String : AnyObject] = ["DollarAmount": textField1.text as AnyObject, "User": user as AnyObject, "Organization": organization as AnyObject]
            let databaseRef = FIRDatabase.database().reference()
            let ref = databaseRef.child("MostRecent").childByAutoId()
            ref.setValue(gameTable)

    }
    @IBAction func subBTN(_ sender: Any) {
        pushToBase()
        let alert = SCLAlertView()
        alert.showSuccess("Thank you for your gift!", subTitle: "")
        textField1.isHidden = true
        //performSegue(withIdentifier: "BackHome", sender: self)
    }
    
}
