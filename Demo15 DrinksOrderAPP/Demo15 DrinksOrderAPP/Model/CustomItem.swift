//
//  CustomItem.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/23.
//

import Foundation

let nohot = ["多冰","標準","微冰","去冰","常溫"]
let normal = ["多冰","標準","微冰","去冰","常溫","熱"]

enum Sagur: String, CaseIterable {
    
    case standard = "全糖"
    case lessSugar = "八分糖"
    case halfSugar = "半糖"
    case quarterSugar = "微糖"
    case sugarFree = "無糖"
    
}

enum Addtion: String, CaseIterable {
    
    case no = "不加料"
    case plum = "梅子兩顆 +$10"
    case smallBubble = "迷你珍珠 +$10"
    case brownsugarBubble = "黑糖珍珠 +$10"
    case bigBubble = "波霸珍珠 +$10"
    case lemon = "檸檬 +$10"
    case coconutjelly = "島嶼椰果 +$10"
    case gressJelly = "手作仙草 +$10"
    
    
}
