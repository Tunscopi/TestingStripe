//
//  SearchTab.swift
//  SeniorProject
//
//  Created by Maalik Hornbuckle on 12/5/16.
//  Copyright © 2016 blah. All rights reserved.
//

        

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

class MasterViewController: UITableViewController {
    
    // MARK: - Properties
    var searches = [SearchItem]()
    var filteredSearches = [SearchItem]()
    var filteredSearches2 = [SearchItem]()
    let searchController = UISearchController(searchResultsController: nil)
    var objectIDs = [String]()
    var collegebusiness = [String]()
    var organizations = [String]()
    var selectedRow = 0
    
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ChariotLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        initVC()
    }
    
    func initVC(){
        var initCount = 0
        let ref = FIRDatabase.database().reference()
        ref.child("NewsFeed").observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary

            for key in snapshot.children {
                self.objectIDs.append((key as AnyObject).key)
            }
            print("Object: ",self.objectIDs)
            
            for object in self.objectIDs{
                ref.child("NewsFeed").child(object).observe(.value, with: { (snapshot) in
                    let snapshotValue = snapshot.value as? NSDictionary
                    self.collegebusiness.append((snapshotValue!["CampaignTitle"] as? String)!)
                    self.organizations.append((snapshotValue!["CampaignStory"] as? String)!)
                    self.tableView.reloadData()
                    //print("CollegeBiz" , self.collegebusiness)
                    //print("organizations" , self.organizations)
                    self.searches.append(SearchItem(collegebusiness: self.collegebusiness[initCount], schoolowner: self.organizations[initCount], category: "School"))
                    initCount+=1
                })
                self.tableView.reloadData()
            }
            self.tableView.reloadData()

        })
        self.tableView.reloadData()

    }
   
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSearches.count
        }
        return searches.count
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredSearches = searches.filter { searching in return searching.collegebusiness.lowercased().contains(searchText.lowercased())
        }
        
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        let searching: SearchItem
        if searchController.isActive && searchController.searchBar.text != "" {
           
            searching =  filteredSearches[indexPath.row]
        }else {
            searching = searches[indexPath.row]
        }
        cell.businessLabel.text = searching.collegebusiness
        cell.ownerLabel.text = searching.schoolowner
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "searchToExpandedSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchToExpandedSegue"){
            let DestViewController : SubmitPaymentViewController = segue.destination as! SubmitPaymentViewController
            DestViewController.objectID = objectIDs[selectedRow]
        }
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
