//
//  SubmitPaymentViewController.swift
//  SeniorProject
//
//  Created by Maalik  on 4/19/17.
//  Copyright © 2017 blah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class SubmitPaymentViewController: UIViewController {
    
    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet var percentageFunded: UILabel!
    @IBOutlet var totalAmountPledged: UILabel!
    @IBOutlet var daysLeftLBL: UILabel!
    @IBOutlet var campaignTitleLBL: UILabel!
    @IBOutlet var descCampLBL: UITextView!
    
    
    var ximage = ""
    var objectID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVC()
        print("Object ID:*********** ",objectID)
        // Do any additional setup after loading the view.
    }
    @IBAction func backBTN(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func loadVC(){
        let ref = FIRDatabase.database().reference()
        let storageRef = FIRStorage.storage().reference()
        ref.child("NewsFeed").child(objectID).observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            
            self.ximage = ((snapshotValue!["PhotoReference"] as? String)!)
            self.campaignTitleLBL.text = ((snapshotValue!["CampaignTitle"] as? String)!)
            self.descCampLBL.text = ((snapshotValue!["CampaignStory"] as? String)!)
            self.percentageFunded.text = ((snapshotValue!["GoalAmount"] as? String)!)
            //self.totalAmountPledged.text = ("$\((snapshotValue!["CurrentAmountPledged"] as? String)!)
            self.percentageFunded.text = "$\(((snapshotValue!["GoalAmount"] as? String)!))"

            self.totalAmountPledged.text = "$\(((snapshotValue!["CurrentAmountPledged"] as? String)!))"
            self.daysLeftLBL.text = ((snapshotValue!["Date"] as? String)!)
            var mountRef = storageRef.child("NewsFeedImg").child((self.ximage))

            DispatchQueue.main.async {
                self.campaignImage.sd_setImage(with: mountRef)
            }
        })}

    

}
