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
    var moviesArray : [ResultModel] = []
    var movieAllData : [ResultModel] = []
    var id = 0
    let rightBarDropDown = DropDown()
    var coreDataArray : [NSManagedObject] = []
    var fetchDataArray : [FavouritMovie] = []
    var flagSort = 0
    let reachability = try! Reachability()
    var appDelegate : AppDelegate!
    var manageObjectContext : NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        createDropDownBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.fetchDataFromApi()
                print("count= \(self.moviesArray.count)")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { [self] _ in
            print("Not reachable")
            fetchAllData()
            moviesArray = movieAllData
            print("movies= \(moviesArray)")
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
    
    func createDropDownBtn(){
        rightBarDropDown.anchorView = navigationController?.navigationBar
        rightBarDropDown.dataSource = ["Highst Rate", "Popularity"]
        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        rightBarDropDown.textColor = .white
        rightBarDropDown.backgroundColor = .black
        rightBarDropDown.semanticContentAttribute = .forceRightToLeft
    }
    
    func fetchDataFromApi(){
//        APINetworkServer().fetchData() { [self] moviesArray, error in
//        if let unwarppedData = moviesArray{
//          self.moviesArray = unwarppedData
//        print(self.moviesArray.count)
//          self.saveMovieData(arraySave: self.moviesArray)
//          DispatchQueue.main.async {
//          self.collectionView.reloadData()
//          }
//        }
//          if let error = error{
//              print(error)
//          }
//         }
        
        MovieAPI().getMovieData { result in
            switch result{
            case .success(let data):
                print("data= \(data!)")
                self.moviesArray = data!.results
                print(self.moviesArray.count)
                self.saveMovieData(arraySave: self.moviesArray)
                DispatchQueue.main.async {
                self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
     }
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SingleMovieCollectionViewCell
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


