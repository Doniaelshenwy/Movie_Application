//
//  Result.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 10/08/2022.
//

import Foundation



struct Result : Codable{
    
    var movieTitle : String
    
    var movieImage : String
    
    var movieOverview : String
    
    var movieRate : Double
    
    var movieReleaseDate : String
    
    var movieID : Int
    
    
    enum CodingKeys: String, CodingKey {
            case movieTitle = "original_title"
        
            case movieImage = "poster_path"
        
            case movieOverview = "overview"
        
            case movieRate = "vote_average"
        
            case movieReleaseDate = "release_date"
        
            case movieID = "id"
        }
     
}

