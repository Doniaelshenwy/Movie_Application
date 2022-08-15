//
//  ReviewsCollectionViewController.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 11/08/2022.
//

import UIKit



class ReviewsCollectionViewController: UICollectionViewController {

    var arrayReview : [ContentResult] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
      
        
        
     
    }

   
    override func viewWillAppear(_ animated: Bool) {
        
        let id = UserDefaults.standard.integer(forKey: "ID")
        print("idddd=\(id)")
        APIReviewServerNetwork().fetchReviewData(id: id) { arrayReview, error in
            
            if let unwarppedData = arrayReview{
              //  print(unwarppedData)
                
                self.arrayReview = unwarppedData
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

                }

            if let error = error{
                print(error)
            }
            
            
        }
       setUPHorizontal()
    }
   
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayReview.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SingleReviewCollectionViewCell
        
        cell.authorNameLabel.text = arrayReview[indexPath.row].author
        cell.reviewLabel.text = arrayReview[indexPath.row].content

        return cell
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

}


extension ReviewsCollectionViewController : UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: screenWi, height: 797)
//    }
//
  
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
       {
           var cellSize:CGSize = CGSize(width: self.collectionView.frame.width, height: 86)
           return cellSize
       }
    
    func setUPHorizontal(){
        
//        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 1)
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 5, trailing: 10)
            let layout = UICollectionViewCompositionalLayout(section: section)
        
             
        
        collectionView.collectionViewLayout = layout
    }
}
