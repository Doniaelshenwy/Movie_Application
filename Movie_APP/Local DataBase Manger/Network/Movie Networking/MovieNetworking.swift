//
//  MovieNetworking.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 01/10/2022.
//

import Foundation

enum MovieNetworking{
    case getMovie
    case getReview
    case getVideo
}

extension MovieNetworking: TargetType{
    var baseURL: String {
        switch self {
        default:
            return "http://api.themoviedb.org/3"
        }
    }
    
    var path: String {
        switch self {
        case .getMovie:
            return "/discover/movie?&api_key=3bfd219a287f476c97bfb68c3b117bf3"
        case .getReview:
            return "/movie/\(UserDefaults.standard.integer(forKey: "ID"))/reviews?&api_key=3bfd219a287f476c97bfb68c3b117bf3&fbclid=IwAR3T9C-Qto4s29yAdoYWkAUhM-slAkQH8olEL4utGpkhL5SRuom9oColQA4"
        case .getVideo:
            return "/movie/\(UserDefaults.standard.integer(forKey: "ID"))/videos?&api_key=3bfd219a287f476c97bfb68c3b117bf3&fbclid=IwAR1CrfbtEsBEQXqcyPPIgmxLJOCOBeb14O6fMphy684mewdPjgsQhMjGgSM"
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var header: [String : String] {
        switch self {
        default:
            return [:]
        }
    }
}
