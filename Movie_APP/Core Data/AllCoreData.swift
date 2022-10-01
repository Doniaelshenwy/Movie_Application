//
//  CoreData.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 17/08/2022.
//

import Foundation
import CoreData


extension MovieListCollectionViewController {
    func saveMovieData(arraySave : [ResultModel]){
        let entity = NSEntityDescription.entity(forEntityName: "AllMovieEntity", in: manageObjectContext)!
        let movie = NSManagedObject(entity: entity, insertInto: manageObjectContext)
        for item in arraySave {
            movie.setValue(item.movieTitle, forKey: "title")
            movie.setValue(item.movieOverview, forKeyPath: "overview")
            movie.setValue(item.movieID, forKey: "id")
            movie.setValue(item.movieRate, forKeyPath: "rate")
            movie.setValue(item.movieReleaseDate, forKey: "releaseDate")
            movie.setValue(item.movieImage, forKey: "img")
        }
        do{
         try manageObjectContext.save()
            print("save data = \(arraySave)")
            print("no save data = \(arraySave.count)")
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func fetchAllData (){
        movieAllData.removeAll()
        let fetchData = NSFetchRequest<NSManagedObject>(entityName: "AllMovieEntity")
        do{
           coreDataArray = try manageObjectContext.fetch(fetchData)
            print("core data array = \(coreDataArray.count)")
            for item in coreDataArray{
                let title = item.value(forKey: "title") as! String
                let id = item.value(forKey: "id") as! Int
                let overview = item.value(forKey: "overview") as! String
                let rate = item.value(forKey: "rate") as! Double
                let releaseDate = item.value(forKey: "releaseDate") as! String
                let img = item.value(forKey: "img") as! String
                let objMovie = ResultModel(movieTitle: title, movieImage: img, movieOverview: overview, movieRate: rate, movieReleaseDate: releaseDate, movieID: id)
                movieAllData.append(objMovie)
                print("title = \(title)")
            }
            print("aaaaaaa = \(movieAllData)")
            print("Fetch Data!")
            collectionView.reloadData()
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}

