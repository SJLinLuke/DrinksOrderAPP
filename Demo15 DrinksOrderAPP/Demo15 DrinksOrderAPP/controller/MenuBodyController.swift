//
//  MenuBodyController.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/21.
//

import Foundation
import UIKit

//My API Key
public let apikey = ""

class MenuBodyController {
    
    static let share = MenuBodyController()
    let baseURL = URL(string: "https://api.airtable.com/v0/appBPkPLBGbKXc7la/DrinkOrderAPP?sort[][field]=category&sort[][direction]=asc")!
    
    func fetchMenuBody(completion: @escaping (Result<MenuBody,Error>)->()) {
        
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let menuResponse = try decoder.decode(MenuBody.self, from: data)
                    completion(.success(menuResponse))
                } catch {
                    completion(.failure(error))
                    print(123)
                    
                }
            } else if let  error = error {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchBodyImage(url: URL, completion:@escaping  (Result<UIImage, Error>)->()) {
        URLSession.shared.dataTask(with: url) {(data ,response, error) in
            if let data =  data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
        
        
    
    
}
