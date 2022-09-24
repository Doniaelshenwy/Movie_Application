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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          //  favouriteArray[indexPath.row].pressFavBtn = false
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
        let fetchData = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")

        do{

           coreDataArray = try manageObjectContext.fetch(fetchData)

           // print("coreDataArray= \(coreDataArray)")
            
            
            //favouriteArray.removeAll()
            
            for item in coreDataArray{

                let title = item.value(forKey: "title") as! String
                
                
                let image = item.value(forKey: "image") as! Data
                
             // let pressFav = item.value(forKey: "pressFavBtn") as! Bool

                let objMovie = FavouritMovie(title: title, image: image)

                favouriteArray.append(objMovie)

            }
           // print("favourite array = \(favouriteArray)")
            tableView.reloadData()

            print("Fetch Data!")
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }



    }

}
