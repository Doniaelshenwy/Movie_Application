//
//  MovieListCollectionViewController.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 10/08/2022.
//

import UIKit
import SDWebImage
import CoreData
import DropDown
import Network
import Reachability



class MovieListCollectionViewController: UICollectionViewController {

    var moviesArray : [Result] = []

    var id = 0
    
    var appDelegate : AppDelegate!
    
    var manageObjectContext : NSManagedObjectContext!
    
    let rightBarDropDown = DropDown()

    var coreDataArray : [NSManagedObject] = []
    
    var fetchDataArray : [FavouritMovie] = []
    
    var arrayName : [String] = []
    
    var sortArrayName : [String] = []
    
    var flagSort = 0
    
    let reachability = try! Reachability()
    
    
    var movieAllData : [AllMovieData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

 

        collectionView.dataSource = self
        collectionView.delegate = self
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
             rightBarDropDown.anchorView = navigationController?.navigationBar
             rightBarDropDown.dataSource = ["Highst Rate", "Popularity"]
             rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
             rightBarDropDown.textColor = .white
             rightBarDropDown.backgroundColor = .black
             rightBarDropDown.semanticContentAttribute = .forceRightToLeft
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                
                        APINetworkServer().fetchData() { moviesArray, error in
                
                                    if let unwarppedData = moviesArray{
                                      //  print(unwarppedData)
                
                                        self.moviesArray = unwarppedData
                
                                        self.saveMovieData(arraySave: self.moviesArray)
                
                                        
                                        DispatchQueue.main.async {
                                            self.collectionView.reloadData()
                                        }
                
                                        print("data view controller")
                                    }
                
                                    if let error = error{
                                        print(error)
                                    }
                
                                }
                
                
                
                
                
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { [self] _ in
            print("Not reachable")
            
            self.fetchAllData()
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        APINetworkServer().fetchData() { moviesArray, error in
//
//                    if let unwarppedData = moviesArray{
//                      //  print(unwarppedData)
//
//                        self.moviesArray = unwarppedData
//
//                    //    self.saveMovieData(arraySave: self.moviesArray)
//
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
//
//                        print("data view controller")
//                    }
//
//                    if let error = error{
//                        print(error)
//                    }
//
//                }
//
//
//
//
//
//
//
    }

    
//    @IBAction func sortBarBtn(_ sender: UIBarButtonItem) {
//        dropDown.show()
//    }
    
    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {

       
         rightBarDropDown.selectionAction = { (index: Int, item: String) in
           print("Selected item: \(item) at index: \(index)")
             
             if index == 0 {
                 self.flagSort = 1
                 
                 for i in self.moviesArray{
                 self.arrayName.append(i.movieTitle)
                 }
                // print(self.arrayName)
                 
                 self.sortArrayName = self.arrayName.sorted()
//                 print("sorted?")
//                 print(self.sortArrayName)
                 
                
                 
                 self.collectionView.reloadData()
             }
             else {
                 
                 
                 
                 
             }
             
         }

         rightBarDropDown.width = 140
         rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
         rightBarDropDown.show()
      }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return moviesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SingleMovieCollectionViewCell
        
        
//        cell.imageMovie.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w185/\(moviesArray[indexPath.row].movieImage)"), placeholderImage: UIImage(named: "iphone.radiowaves.left.and.right"))
//
        if flagSort == 0 {
            
            cell.imageMovie.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w185/\(moviesArray[indexPath.row].movieImage)"), placeholderImage: UIImage(named: "iphone.radiowaves.left.and.right"))
            
          //  print("first")
            
           
           
        }
        else {
            if moviesArray[indexPath.row].movieTitle == sortArrayName[indexPath.row]{
                
                
                
                
                cell.imageMovie.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w185/\(moviesArray[indexPath.row].movieImage)"), placeholderImage: UIImage(named: "iphone.radiowaves.left.and.right"))
               // print("yees")
            }
            
        }
        
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController{
//
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
        
        id = moviesArray[indexPath.row].movieID
        
        UserDefaults.standard.set(id, forKey: "ID")
        
       
        
      //  print("id=\(id)")
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            
            vc.id = id
            vc.img = moviesArray[indexPath.row].movieImage
            vc.overView = moviesArray[indexPath.row].movieOverview
            vc.release = moviesArray[indexPath.row].movieReleaseDate
            vc.titleMovie = moviesArray[indexPath.row].movieTitle
            vc.rateMovie = moviesArray[indexPath.row].movieRate
            
            UserDefaults.standard.set(moviesArray[indexPath.row].movieTitle, forKey: "title")
            UserDefaults.standard.set(moviesArray[indexPath.row].movieImage, forKey: "image")
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    
    func setUPHorizontal() {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)), subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        collectionView.collectionViewLayout = layout
    }
 
}



extension MovieListCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 350)
    }
    
    
    



}
