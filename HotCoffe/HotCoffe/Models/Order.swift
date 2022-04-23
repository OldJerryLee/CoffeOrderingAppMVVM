//
//  Order.swift
//  HotCoffe
//
//  Created by Fabricio Pujol on 23/04/22.
//

import Foundation

enum CoffeType: String, Codable {
    case cappuccino
    case latte
    case espressino
    case cortado
}

enum CoffeSise: String, Codable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeType
    let size: CoffeSise
}
