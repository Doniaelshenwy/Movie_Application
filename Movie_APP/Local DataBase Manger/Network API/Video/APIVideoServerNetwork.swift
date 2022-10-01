//
//  APIVideoServerNetwork.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 13/08/2022.
//

import Foundation
import Alamofire

class APIVideoServerNetwork{
    var videoArray : [VideoResult] = []
    func fetchVideoData(id : Int,Compilation: @escaping([VideoResult]?, String?)->(Void)){
        let url = "https://api.themoviedb.org/3/movie/\(id)/videos?&api_key=3bfd219a287f476c97bfb68c3b117bf3&fbclid=IwAR1CrfbtEsBEQXqcyPPIgmxLJOCOBeb14O6fMphy684mewdPjgsQhMjGgSM"
        if let url = URL(string: url){
            let request = AF.request(url,method: .get,encoding: URLEncoding.default)
            request.responseJSON { [self]responseData in
            if let data = responseData.data{
               let jsonDecoderData = JSONDecoder()
                if let decodedData = try?jsonDecoderData.decode(Videos.self, from: data){
                    self.videoArray = decodedData.results
                    Compilation(self.videoArray, nil)
                    }
                }
            if let error = responseData.error{
                let stringError = error.localizedDescription
                self.videoArray = []
                print(error.localizedDescription)
                Compilation(self.videoArray, stringError)
            }
            }
        }
    }
}

