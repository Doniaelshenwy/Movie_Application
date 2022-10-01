//
//  MovieAPI.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 01/10/2022.
//

import Foundation

class MovieAPI: BaseAPI<MovieNetworking>{
    func getMovieData(complition: @escaping(Result<[ResultModel]?, NSError>)-> Void){
        fetchDataFromAPIGeneric(target: .getMovie, response: [ResultModel].self) { result in
            complition(result)
        }
    }
    
    func getReviewData(complition: @escaping (Result<Reviews?, NSError>)-> Void){
        fetchDataFromAPIGeneric(target: .getReview, response: Reviews.self) { result in
            complition(result)
        }
    }
    
    func getReviewData(complition: @escaping (Result<Videos?, NSError>)-> Void){
        fetchDataFromAPIGeneric(target: .getVideo, response: Videos.self) { result in
            complition(result)
        }
    }
}
