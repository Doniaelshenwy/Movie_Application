//
//  CoreDatafavouriteMovie.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 23/08/2022.
//

import Foundation
import CoreData


extension DetailsViewController{
    

        func saveFavouriteMovie(){
          
            
            let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: manageObjectContext)!
            
            let movie = NSManagedObject(entity: entity, insertInto: manageObjectContext)
           print("Save?")


            movie.setValue("Donia", forKey: "title")
            
            do{
             try manageObjectContext.save()
                
                print("save data")
                
                
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
            
        }
        
    }


    
    

