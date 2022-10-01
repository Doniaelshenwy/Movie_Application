//
//  APIReviewServerNetwork.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 11/08/2022.
//

import Foundation
import Alamofire

class APIReviewServerNetwork{
    var reviewArray : [ContentResult] = []
    func fetchReviewData(id : Int,Compilation: @escaping([ContentResult]?, String?)->(Void)){
        let url = "https://api.themoviedb.org/3/movie/\(id)/reviews?&api_key=3bfd219a287f476c97bfb68c3b117bf3&fbclid=IwAR3T9C-Qto4s29yAdoYWkAUhM-slAkQH8olEL4utGpkhL5SRuom9oColQA4"
        if let url = URL(string: url){
            let request = AF.request(url,method: .get,encoding: URLEncoding.default)
            request.responseJSON { [self]responseData in
            if let data = responseData.data{
               let jsonDecoderData = JSONDecoder()
                if let decodedData = try?jsonDecoderData.decode(Reviews.self, from: data){
                    self.reviewArray = decodedData.results
                    Compilation(self.reviewArray, nil)
                    }
                }
            if let error = responseData.error{
                let stringError = error.localizedDescription
                self.reviewArray = []
                print(error.localizedDescription)
                Compilation(self.reviewArray, stringError)
            }
            }
        }
    }
}
