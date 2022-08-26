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
      
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: manageObjectContext)!
        
        let movie = NSManagedObject(entity: entity, insertInto: manageObjectContext)
       print("Save?")
        //print(moviesArray)
        for item in moviesArray {
            print(item.movieTitle)
            movie.setValue(item.movieTitle, forKey: "title")
            movie.setValue(item.movieOverview, forKeyPath: "overview")
            movie.setValue(item.movieID, forKey: "id")
            movie.setValue(item.movieRate, forKeyPath: "rate")
            movie.setValue(item.movieReleaseDate, forKey: "releaseDate")
           
        }
        
       
        
        do{
         try manageObjectContext.save()
            
            print("save data")
            
            
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
}

