//
//  MenuBody.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/21.
//

import Foundation

struct MenuBody: Codable {
    var records: [Records]
    struct Records: Codable {
        var fields: Fields
        struct Fields: Codable {
            var drinksname: String
            var price: Int
            var category: String
            var hot: Bool?
            var icefree: Bool?
            var image: [image]
            struct image: Codable {
                var url: URL
            }
        }
    }
}

struct OrderDetail {
    var name: String
    var hot: Bool?
    var image: URL
    var icefree: Bool?
    var price: Int
    var category: String
}
