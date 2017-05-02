//
//  PushToFirebase.swift
//  SeniorProject
//
//  Created by Jacari Boboye on 1/29/17.
//  Copyright © 2017 blah. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class PushToFirebase : UIViewController{
    
    @IBOutlet var titleOfCampusIntiativeTF: UITextField!
    @IBOutlet var durationTF: UITextField!
    @IBOutlet var endGoalTF: UITextField!
    @IBOutlet var descriptionTF: UITextField!
    
    override func viewDidLoad(){}
    
    @IBAction func submitBTN(_ sender: Any) {
        let gameTable : [String : AnyObject] = ["InitiativeTitle": titleOfCampusIntiativeTF.text as AnyObject, "Duration": durationTF.text as AnyObject, "EndGoal": endGoalTF.text as AnyObject, "Description": descriptionTF.text as AnyObject]
        let databaseRef = FIRDatabase.database().reference()
        let ref = databaseRef.child("NewsFeed").childByAutoId()
        ref.setValue(gameTable)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBarController
    }
}
