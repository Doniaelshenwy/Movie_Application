//
//  MovieAPI.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 01/10/2022.
//

import Foundation

class MovieAPI: BaseAPI<MovieNetworking>{
    func getMovieData(complition: @escaping(Result<Movies?, NSError>)-> Void){
        fetchDataFromAPIGeneric(target: .getMovie, response: Movies.self) { result in
            complition(result)
        }
    }
    
    func getReviewData(complition: @escaping (Result<Reviews?, NSError>)-> Void){
        fetchDataFromAPIGeneric(target: .getReview, response: Reviews.self) { result in
            complition(result)
        }
    }
    
    func getVideoData(complition: @escaping (Result<Videos?, NSError>)-> Void){
        fetchDataFromAPIGeneric(target: .getVideo, response: Videos.self) { result in
            complition(result)
        }
    }
}
