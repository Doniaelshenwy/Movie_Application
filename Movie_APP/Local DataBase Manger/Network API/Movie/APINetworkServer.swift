//
//  APINetworkServer.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 10/08/2022.
//

import Foundation
import Alamofire

class APINetworkServer{
    var movieArr : [ResultModel] = []
     func fetchData(Compilation: @escaping([ResultModel]?, String?)->(Void)){
        let url = "http://api.themoviedb.org/3/discover/movie?&api_key=3bfd219a287f476c97bfb68c3b117bf3"
        if let url = URL(string: url){
            let request = AF.request(url,method: .get,encoding: URLEncoding.default)
            request.responseJSON { [self]responseData in
            if let data = responseData.data{
               let jsonDecoderData = JSONDecoder()
                if let decodedData = try?jsonDecoderData.decode(Movies.self, from: data){
                    self.movieArr = decodedData.results
                    Compilation(self.movieArr, nil)
                    }
                }
            if let error = responseData.error{
                let stringError = error.localizedDescription
                self.movieArr = []
                print(error.localizedDescription)
                Compilation(self.movieArr, stringError)
            }
            }
        }
    }
}
