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

    override func viewDidLoad() {
        super.viewDidLoad()

     
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        fetchFavouriteData()
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favouriteArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleFavouriteTableViewCell
        
        
        
        cell.titleMovie.text = favouriteArray[indexPath.row].name

        cell.imageMovie.sd_setImage(with: URL(string: "\(favouriteArray[indexPath.row].img)"), placeholderImage: UIImage(named: "iphone.radiowaves.left.and.right"))


     
     

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func fetchFavouriteData (){
        
        favouriteArray.removeAll()
        let fetchData = NSFetchRequest<NSManagedObject>(entityName: "MovieFavourite")
        
        do{
           
           coreDataArray = try manageObjectContext.fetch(fetchData)
            
            for item in coreDataArray{
                
                let title = item.value(forKey: "movieTitle") as! String
                let image = item.value(forKey:"movieImage")
                
              print("img is \(image)")
                
               
                let objMovie = FavouritMovie( img: image as! String, name: title)
                
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
