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
import Kingfisher

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
    var movieAllData : [Result] = []
    var flagImg = 0
    var pressStar = false
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
        
    
//        fetchAllData()
//        moviesArray = movieAllData

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                APINetworkServer().fetchData() { [self] moviesArray, error in
                if let unwarppedData = moviesArray{
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
            moviesArray = movieAllData
            print("moviessssss= \(moviesArray)")
            for i in moviesArray{
                print("urllll = \(i.movieImage)")
            }
            collectionView.reloadData()
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    


    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {

         rightBarDropDown.selectionAction = { (index: Int, item: String) in
           print("Selected item: \(item) at index: \(index)")
             
             if index == 0 {
                 self.flagSort = 1
                 
                 for item in self.moviesArray{
                     self.moviesArray.sort(by: {$0.movieRate > $1.movieRate})
                 }
                 self.collectionView.reloadData()
             }
             else {
                 
                 for item in self.moviesArray{
                     self.moviesArray.sort(by: {$0.movieTitle > $1.movieTitle})
                 }
                 self.collectionView.reloadData()
             }
         }
         rightBarDropDown.width = 140
         rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
         rightBarDropDown.show()
      }

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
//            cell.imageMovie.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w185/\(moviesArray[indexPath.row].movieImage)"), placeholderImage: UIImage(named: "iphone.radiowaves.left.and.right"))
        
        
        cell.imageMovie.kf.indicatorType = .activity
            cell.imageMovie.kf.setImage(with: URL(string: "http://image.tmdb.org/t/p/w185/\(moviesArray[indexPath.row].movieImage)"))
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        id = moviesArray[indexPath.row].movieID
        UserDefaults.standard.set(id, forKey: "ID")
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


