//
//  NetworkingService.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//

import Foundation
class NetworkingService{
    private init() {}
    static let shered = NetworkingService()
    func request(_ urlPath: URLRequest, completion: @escaping (Result<Data, NSError>)-> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: urlPath){
            (data, _,error) in
                if let unwrappedError = error{
                    completion(.failure(unwrappedError as NSError))
                }else if let unwrapedData = data{
                    completion(.success(unwrapedData))
                }
        }
        task.resume()
    }
}
