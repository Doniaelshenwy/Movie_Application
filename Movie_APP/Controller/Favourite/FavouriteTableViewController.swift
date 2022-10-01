//
//  FavouriteTableViewController.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 15/08/2022.
//

import UIKit
import SDWebImage
import CoreData

class FavouriteTableViewController: UITableViewController {
    var favouriteArray : [FavouritMovie] = []
    var coreDataArray : [NSManagedObject] = []
    var appDelegate : AppDelegate!
    var manageObjectContext : NSManagedObjectContext!
    var objDetails : DetailsViewController!
    var userDefaultFavBtn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        objDetails = DetailsViewController()
        userDefaultFavBtn = UserDefaults.standard.bool(forKey: "FavBtn")
    }

    override func viewWillAppear(_ animated: Bool) {
       fetchFavouriteData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count= \(favouriteArray.count)")
        return favouriteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleFavouriteTableViewCell
        cell.titleMovie.text = favouriteArray[indexPath.row].title
        print("show")
        cell.imageMovie.image = UIImage(data: favouriteArray[indexPath.row].image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favouriteArray.remove(at: indexPath.row)
            manageObjectContext.delete(coreDataArray[indexPath.row])
            objDetails.imageStarFill = UIImage(systemName: "star")
            UserDefaults.standard.set(true, forKey: "FavBtn")
            do{
                try manageObjectContext.save()
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func fetchFavouriteData (){
        favouriteArray.removeAll()
        let fetchData = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        do{
           coreDataArray = try manageObjectContext.fetch(fetchData)
            for item in coreDataArray{
                let title = item.value(forKey: "title") as! String
                let image = item.value(forKey: "image") as! Data
                let objMovie = FavouritMovie(title: title, image: image)
                favouriteArray.append(objMovie)
            }
            tableView.reloadData()
            print("Fetch Data!")
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}
