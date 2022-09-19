//
//  CoreData.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 17/08/2022.
//

import Foundation
import CoreData


extension MovieListCollectionViewController {
    
    
    
    func saveMovieData(arraySave : [Result]){
      
        
        let entity = NSEntityDescription.entity(forEntityName: "AllMovieEntity", in: manageObjectContext)!
        
        let movie = NSManagedObject(entity: entity, insertInto: manageObjectContext)
       print("Save all Data?")
        //print(moviesArray)
        for item in moviesArray {
            print(item.movieTitle)
            movie.setValue(item.movieTitle, forKey: "title")
            movie.setValue(item.movieOverview, forKeyPath: "overview")
            movie.setValue(item.movieID, forKey: "id")
            movie.setValue(item.movieRate, forKeyPath: "rate")
            movie.setValue(item.movieReleaseDate, forKey: "releaseDate")
            movie.setValue("http://image.tmdb.org/t/p/w185/\(item.movieImage)", forKey: "img")
        }
        
       
        
        do{
         try manageObjectContext.save()
            
            print("save data")
            
            
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

            
            for item in coreDataArray{

                let title = item.value(forKey: "title") as! String
                
                let id = item.value(forKey: "id") as! Int
                
                let overview = item.value(forKey: "overview") as! String
                
                let rate = item.value(forKey: "rate") as! Double
                
                let releaseDate = item.value(forKey: "releaseDate") as! String
                
                let img = item.value(forKey: "img") as! String

             

                let objMovie = AllMovieData(id: id, img: img,overview: overview, rate: rate, releaseDate: releaseDate, title: title)

                movieAllData.append(objMovie)

            }
           
            collectionView.reloadData()

            print("Fetch Data!")
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }



    }

    
}

