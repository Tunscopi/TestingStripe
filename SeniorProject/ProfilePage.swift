//
//  ProfilePage.swift
//  SeniorProject
//
//  Created by Jacari Boboye on 11/19/16.
//  Copyright © 2016 blah. All rights reserved.
//

import Foundation
import UIKit

var userID = ""

class ProfilePage : UIViewController{
    @IBOutlet var scroller: UIScrollView!
    @IBOutlet var ImagePlaceHolder: UIImageView!
    
    override func viewDidLoad(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ChariotLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        self.ImagePlaceHolder.layer.cornerRadius = self.ImagePlaceHolder.frame.size.width / 2;
        self.ImagePlaceHolder.clipsToBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
        scroller.contentInset = UIEdgeInsets.zero
        scroller.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scroller.contentSize = CGSize(width: scroller.frame.width, height: 1000)
    }
    
    @IBAction func inviteFriends(_ sender: Any)  {
        let variable  = "Download the app"
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [variable], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    @IBAction func ShareBTN(_ sender: Any) {
        let variable  = "Download the app"
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [variable], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
       
    }
    
}
