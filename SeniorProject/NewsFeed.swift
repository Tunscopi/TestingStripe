//
//  NewsFeed.swift
//  SeniorProject
//
//  Created by Maalik Hornbuckle on 12/4/16.
//  Copyright © 2016 blah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseStorageUI

class NewsFeed: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right:5.0)
    fileprivate let itemsPerRow: CGFloat = 1
    
    var objectIDs = [String]()
    var imageKeys = [String]()

//    var photos = [#imageLiteral(resourceName: "engineering"),#imageLiteral(resourceName: "schoolofc"),#imageLiteral(resourceName: "schoolofb"),#imageLiteral(resourceName: "hulaw") ,#imageLiteral(resourceName: "dentalschool"),#imageLiteral(resourceName: "PHARMACY"),#imageLiteral(resourceName: "EDUCATION")]
//    var initiative = ["COLLEGE OF ENGINEERING AND ARCHITECTURE","SCHOOL OF COMMUNICATIONS","SCHOOL OF BUSINESS","HU LAW","COLLEGE OF DENTISTRY","COLLEGE OF PHARMACY","SCHOOL OF EDUCATION"]
//    var damount = [3000,2100,7000,5100,2500,1000,3400]
//    var backers = [160,100,175,99,100,121,140]
//    var daystogo = [30,30,30,30,30,30,30]
//    var totpledge = [10000,10000,10000,10000,10000,10000,10000]
    var selectedPath = 0
    
    override func viewDidLoad() {
        UIApplication.shared.isStatusBarHidden = false
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ChariotLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        initVC()
    }
    func initVC(){
        let ref = FIRDatabase.database().reference()
        ref.child("NewsFeed").observe(.value, with: { (snapshot) in
            for key in snapshot.children {
                self.objectIDs.append((key as AnyObject).key)
            }
            print("Object: ",self.objectIDs)
            self.getImageKeys()
            self.myCollectionView.reloadData()
        })
    }
    
    func getImageKeys(){
        for object in objectIDs{
        let ref = FIRDatabase.database().reference()
        ref.child("NewsFeed").child(object).observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
                self.imageKeys.append((snapshotValue!["PhotoReference"] as? String)!)
        })}
    }

    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Iniative count is \(self.objectIDs.count)")
        return self.objectIDs.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! HomeCell
        
        
        let storageRef = FIRStorage.storage().reference()
        let ref = FIRDatabase.database().reference()
        ref.child("NewsFeed").child(objectIDs[indexPath.row]).observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            print("IMAGE KEY!!!!!", self.imageKeys)
           // let mountRef = storageRef.child("NewsFeedImg").child("\(((snapshotValue!["imageRef"] as? String)!)).jpg")
//            if self.imageKeys[indexPath.row] != ""{
                var mountRef = storageRef.child("NewsFeedImg").child((self.imageKeys[indexPath.row] as? String)!)
  //          }
    //        else{
      ///      }
            
            //CampaginOwner, campaignStory, *campaignTitle, *photoReference, websiteLink
            ///Dynamic
            cell.mainLabel.text = ((snapshotValue!["CampaignTitle"] as? String)!)
            cell.donationAmount.text = "$\(((snapshotValue!["GoalAmount"] as? String)!))"
            cell.days2go.text = String(((snapshotValue!["Date"] as? String)!))
            cell.totalpledge.text = ((snapshotValue!["Date"] as? String)!)
            
            print("DonationAmount", cell.donationAmount.text!)
            print("TotalAmount", cell.totalpledge.text!)

            //cell.DonorProgress.progress = Float(Float(cell.donationAmount.text!)!)/Float(cell.totalpledge.text!)!
            cell.totalpledge.text = "PLEDGED OF TOTAL $\(((snapshotValue!["Date"] as? String)!))"

            
            //Static
           // cell.images.image = self.photos[indexPath.item]
            cell.backgroundColor = UIColor.gray
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 2
                        DispatchQueue.main.async {
//                            if self.imageKeys[indexPath.row] != ""{
                                cell.images.sd_setImage(with: mountRef)}
            //}
        })
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        self.selectedPath = indexPath.row
        print("You selected cell #\(indexPath.item)!")
        performSegue(withIdentifier: "NewsFeedToExpandedSegue", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewsFeedToExpandedSegue"){
            let DestViewController : SubmitPaymentViewController = segue.destination as! SubmitPaymentViewController
            DestViewController.objectID = objectIDs[selectedPath]
        }
    }
}

extension NewsFeed : UICollectionViewDelegateFlowLayout {
    
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        //let availableWidth = (self.view.frame.size.width/CGFloat(itemsPerRow)) //view.frame.width - paddingSpace
        let widthPerItem : CGFloat =  (self.view.frame.size.width/CGFloat(itemsPerRow)) - CGFloat(paddingSpace)
        //let widthPerItem = availableWidth / itemsPerRow
        
        let setHeight = (self.view.frame.size.height/3)
        
        return CGSize(width: widthPerItem, height: setHeight)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension UIImageView {
    
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
    }
}
