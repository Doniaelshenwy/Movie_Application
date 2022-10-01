//
//  TargetType.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 01/10/2022.
//

import Foundation
import Alamofire

enum HTTPMethod: String{
    case get = "GET"
}

enum Task{
    case requestPlain
    case requestParamter(paramters: [String: Any], encoding: ParameterEncoding)
}

protocol TargetType{
    var baseURL: String { get }
    var path: String { get }
    var task: Task { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
}

