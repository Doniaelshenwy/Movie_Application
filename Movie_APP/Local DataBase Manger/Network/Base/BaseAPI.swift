//
//  BaseAPI.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 01/10/2022.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType>{
    func fetchDataFromAPIGeneric<M: Decodable>(target: T, response: M.Type, completion: @escaping(Result<M?, NSError>) -> Void){
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let header = Alamofire.HTTPHeaders(target.header)
        let parameter = buildParameter(task: target.task)
        AF.request(target.baseURL + target.path, method: method, parameters: parameter.0, encoding: parameter.1, headers: header).response { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            if statusCode <= 299{
                switch dataResponse.result {
                case .success(let data):
                    if let decodedData = try? JSONDecoder().decode(M.self, from: data!){
                        completion(.success(decodedData))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func buildParameter(task: Task) -> ([String: Any], ParameterEncoding){
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParamter(let paramters, let encoding):
            return (paramters, encoding)
        }
    }
}
