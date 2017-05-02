//
//  LoginVC.swift
//  SeniorProject
//
//  Created by Jacari Boboye on 11/22/16.
//  Copyright © 2016 blah. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class LoginVC : UIViewController, UITextFieldDelegate{
    var register = false
    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var logORRegBTN: UIButton!
    @IBOutlet var LoginRegSwitch: UIButton!
    
    @IBOutlet var textField1: UITextField!
    
    @IBOutlet var textField2: UITextField!
    override func viewDidLoad() {
        UIApplication.shared.isStatusBarHidden = true
        textField1.delegate = self
        textField2.delegate = self

    }
    func login(){
        FIRAuth.auth()?.signIn(withEmail: usernameTF.text!, password: passwordTF.text!, completion: {
            user, error in
            if error != nil{
                print("Try again")
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarController
                self.performSegue(withIdentifier: "GoodLogin", sender: self)
            
            }
        })
    }
    func registerNewUser(){
        let ref = FIRDatabase.database().reference()
        let table : [String:AnyObject] = ["Name" : "" as AnyObject, "Bio" : "" as AnyObject, "ProfilePic": "" as AnyObject]
        
        if(register == true){
            FIRAuth.auth()?.createUser(withEmail: usernameTF.text!, password: passwordTF.text!, completion: {
                user,error in
                if error != nil{//Found
                    self.login()
                }
                else{//If not found
                    print("User created")
                    let userRef = ref.child("Users/\(FIRAuth.auth()!.currentUser!.uid)").child("userInfo")
                    userRef.setValue(table)
                    self.login()
                }
            })
        }
        else{
            self.login()
        }
        
    }
    
    @IBAction func loginGo(_ sender: Any) {
        registerNewUser()
    }
    @IBAction func forgotPass(_ sender: Any) {
    }
    @IBAction func registerBTN(_ sender: Any) {
        if(register == false){
            register = true
            logORRegBTN.setTitle("REGISTER", for: UIControlState.normal)
            LoginRegSwitch.setTitle("LOGIN", for: UIControlState.normal)
        }
        else{
            register = false
            logORRegBTN.setTitle("LOGIN", for: UIControlState.normal)
            LoginRegSwitch.setTitle("REGISTER", for: UIControlState.normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewsFeedToExpandedSegue"){
            let DestViewController : SubmitPaymentViewController = segue.destination as! SubmitPaymentViewController
           // DestViewController.objectID = objectIDs[selectedPath]
        }
    }
}

    



