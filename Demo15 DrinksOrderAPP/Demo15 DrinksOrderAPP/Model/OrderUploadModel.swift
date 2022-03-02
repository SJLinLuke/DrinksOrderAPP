//
//  OrderUploadModel.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/25.
//

import Foundation
import FileProvider

//暫存
struct OrderStore: Codable {
    var orderstore: [OrderUpload.Records]
    
    init(orderstore: [OrderUpload.Records] = []) {
        self.orderstore = orderstore
    }
}


//上傳
struct OrderUpload: Codable {
    var records: [Records]
    struct Records: Codable {
        var fields: Fields
        struct Fields: Codable {
            var name: String
            var imageurl: URL
            var drinkname: String
            var drinksugar: String
            var drinkaddtion: String
            var drinktempuretrue: String
            var quantity: Int
            var remark: String?
            var price: Int
            var id: String
        }
    }
}

//下載
struct OrderDownload: Codable {
    var records: [Records]
    struct Records: Codable {
        var id: String
        var fields: OrderUpload.Records.Fields
}
}
