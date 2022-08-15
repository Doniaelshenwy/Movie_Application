//
//  ExtensionDetailsViewController.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 15/08/2022.
//

import Foundation
import CoreData

extension DetailsViewController {
    
    
    
    func saveFavouriteMovie(){
        let title = UserDefaults.standard.string(forKey: "title")
        let image = UserDefaults.standard.string(forKey: "image")
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieFavourite", in: manageObjectContext)!
        
        let movie = NSManagedObject(entity: entity, insertInto: manageObjectContext)
        
        let imageData = "http://image.tmdb.org/t/p/w185/\(image)"
        
        movie.setValue(title, forKey: "movieTitle")
        movie.setValue(imageData, forKeyPath: "movieImage")
        
        do{
         try manageObjectContext.save()
            
            print("save data")
            print("title is \(title) and image is \(imageData)")
            
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
}
