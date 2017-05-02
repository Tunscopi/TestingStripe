
//  SeniorProject
//
//  Created by Maalik  on 4/19/17.
//  Copyright © 2017 blah. All rights reserved.
//

import UIKit

class MostRecent: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    var donors = ["John Smith", "Legand Burge", "Will Johnson"]
    
    var campaigns = ["College of Engineering and Architecture", "NSBE", "The Dental School"]
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 1.0, right:1.0)
    fileprivate let itemsPerRow: CGFloat = 1

    
    var amount = [ 150, 200, 400
    ]
    
    var userimage = [ #imageLiteral(resourceName: "userimage"), #imageLiteral(resourceName: "userimage"), #imageLiteral(resourceName: "userimage")]
    
    
    var campaignimage = [
        #imageLiteral(resourceName: "engineering"), #imageLiteral(resourceName: "CEACSLogo"), #imageLiteral(resourceName: "dentalschool")
    ]
    
    override func viewDidLoad() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ChariotLogo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.donors.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MostRecentCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = "\(self.donors[indexPath.item]) donated \(self.amount[indexPath.item]) to \(self.campaigns[indexPath.item])"
        cell.userIcon.image = self.userimage[indexPath.item]
        cell.campaignIcon.image = self.campaignimage[indexPath.item]
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
}



extension MostRecent : UICollectionViewDelegateFlowLayout {
    
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        //let availableWidth = (self.view.frame.size.width/CGFloat(itemsPerRow)) //view.frame.width - paddingSpace
        let widthPerItem : CGFloat =  (self.view.frame.size.width/CGFloat(itemsPerRow)) - CGFloat(paddingSpace)
        //let widthPerItem = availableWidth / itemsPerRow
        
        let setHeight = (self.view.frame.size.height/8)
        
        print("Width is:\(widthPerItem)")
        print("Height is:\(setHeight)")
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
    
    func tintColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
    }
}
