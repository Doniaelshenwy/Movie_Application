//
//  MovieFavourite+CoreDataProperties.swift
//  
//
//  Created by Donia Elshenawy on 16/08/2022.
//
//

import Foundation
import CoreData


extension MovieFavourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieFavourite> {
        return NSFetchRequest<MovieFavourite>(entityName: "MovieFavourite")
    }

    @NSManaged public var movieImage: Data?
    @NSManaged public var movieTitle: String?

}
