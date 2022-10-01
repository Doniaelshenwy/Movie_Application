//
//  DetailsViewController.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 11/08/2022.
//

import UIKit
import SDWebImage
import Cosmos
import youtube_ios_player_helper
import CoreData


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var favouriteBtnStar: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageMovieImageView: UIImageView!
    @IBOutlet weak var raleaseMovieLabel: UILabel!
    @IBOutlet weak var overViewMovieLabel: UILabel!
    @IBOutlet weak var reviewMovieTextView: UITextView!
    var appDelegate : AppDelegate!
    var manageObjectContext : NSManagedObjectContext!
    var reviewArray : [ContentResult] = []
    var videoArray : [VideoResult] = []
    var titleMovie = ""
    var release = ""
    var overView = ""
    var img = ""
    var rateMovie = 0.0
    var id = 0
    var review  = ""
    var pressedBtn = false
    var stringArray : [String] = []
    var imageStarEmpty = UIImage(systemName: "star")
    var imageStarFill = UIImage(systemName: "star.fill")
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewMovieTextView.isEditable = false
        setDataOfUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        setUPHorizontal()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchVideoFromAPI()
        fetchReviewFromAPI()
//        APIReviewServerNetwork().fetchReviewData(id: id) { arrayReview, error in
//            if let unwarppedData = arrayReview{
//                self.reviewArray = unwarppedData
//                for item in self.reviewArray{
//                    let d = item.content
//                    self.review = self.review + " " + d
//                }
//                self.reviewMovieTextView.text = self.review
//            }
//            if let error = error{
//                print(error)
//            }
//        }
//        APIVideoServerNetwork().fetchVideoData(id: id) { arrayVideo, error in
//            if let unwarppedData = arrayVideo{
//                self.videoArray = unwarppedData
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//                }
//            if let error = error{
//                print(error)
//            }
//        }
    }
    
    @IBAction func favouritMovieBtn(_ sender: UIButton) {
        pressedBtn = !pressedBtn
        if pressedBtn == false {
            sender.setImage(imageStarEmpty, for: .normal)
            pressedBtn = false
            UserDefaults.standard.set(pressedBtn, forKey: "FavBtn")
        }
        else{
            sender.setImage(imageStarFill, for: .normal)
            pressedBtn = true
            UserDefaults.standard.set(pressedBtn, forKey: "FavBtn")
           saveMovieInFavourite()
        }
    }
    
    @IBAction func detailsReviewBtn(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsTableViewController") as? ReviewsTableViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetchReviewFromAPI(){
        MovieAPI().getReviewData { result in
            switch result{
            case .success(let data):
                self.reviewArray = data!.results
                for item in self.reviewArray{
                    let d = item.content
                    self.review = self.review + " " + d
                }
                self.reviewMovieTextView.text = self.review
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchVideoFromAPI(){
        MovieAPI().getVideoData { result in
            switch result{
            case .success(let data):
                self.videoArray = data!.results
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setDataOfUI(){
        reviewMovieTextView.isEditable = false
        titleMovieLabel.text = titleMovie
        raleaseMovieLabel.text = release
        overViewMovieLabel.text = overView
        imageMovieImageView.sd_setImage(with: URL(string: "http://image.tmdb.org/t/p/w185/\(img)"), placeholderImage: UIImage(named: "iphone.radiowaves.left.and.right"))
        cosmosView.settings.fillMode = .precise
        cosmosView.rating = rateMovie / 2.0
        cosmosView.tintColor = UIColor.orange
    }
    
    func saveMovieInFavourite(){
        var imageFav = imageMovieImageView.image?.pngData()
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: manageObjectContext)!
        let movie = NSManagedObject(entity: entity, insertInto: manageObjectContext)
        print("title= \(titleMovie)")
        movie.setValue(titleMovie, forKey: "title")
        movie.setValue(imageFav, forKey: "image")
        print("pressed fav = \(pressedBtn)")
        do{
            try manageObjectContext.save()
            print("save title")
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}

extension DetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCollectionViewCell
        cell.viewer.load(withVideoId: "\(videoArray[indexPath.row].key)")
        return cell
    }
    
    func setUPHorizontal() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }
    }



