//
//  OrderController.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/25.
//
import UIKit
import Foundation

class OrderController {
    
    var apikey = "keye2jJ2wDQ2630Bb"
    
    static let shared = OrderController()
    
    private let baseURL = URL(string: "https://api.airtable.com/v0/appBPkPLBGbKXc7la/order?sort[][field]=id&sort[][direction]=desc")
    
    static let orderUpdateNotification = Notification.Name("OrderController.OrderUpdate")
    var order = OrderStore() {
        didSet{
            NotificationCenter.default.post(name: Self.orderUpdateNotification, object: nil)
        }
    }
    
    //上傳訂單到airtable
    func PostOrder(url: URL, data: OrderUpload, completion:@escaping (Result<String,Error>) -> ()) {
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(data)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if data != nil {
                completion(.success("發送成功"))
                print("成功")
            }else if let error = error{
                completion(.failure(error))
            }

         }.resume()
     }
    
    
    //從airtable下載訂單
    func fetchOrder(completion: @escaping (Result<[OrderDownload.Records], Error>) -> ()) {
        
        var request = URLRequest(url: baseURL!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, Error) in
            
            if let data = data {
                do {
                    let OrderResponse = try JSONDecoder().decode(OrderDownload.self, from: data)
                    completion(.success(OrderResponse.records))
                    
                } catch {
                    completion(.failure(error))
                    print("失敗")
                }
            }
        }.resume()
        
    }
    
    //刪除訂單
    func deleteOrder(orderID: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let url = URL(string: "https://api.airtable.com/v0/appBPkPLBGbKXc7la/order/\(orderID)")else{return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error == nil {
                completion(.success("刪除"))
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }

}
