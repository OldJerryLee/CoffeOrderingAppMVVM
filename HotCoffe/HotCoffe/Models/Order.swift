//
//  Order.swift
//  HotCoffe
//
//  Created by Fabricio Pujol on 23/04/22.
//

import Foundation

enum CoffeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espressino
    case cortado
}

enum CoffeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeType
    let size: CoffeSize
}

extension Order {

    init?(_ vm: AddCoffeOrderViewModel) {
        guard let name = vm.name,
              let email = vm.email,
              let selectedType = CoffeType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = CoffeSize(rawValue: vm.selectedSize!.lowercased()) else {
            return nil
        }

        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}

extension Order {

    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect!")
        }

        return Resource<[Order]>(url: url)
    }()

    static func create(vm: AddCoffeOrderViewModel) -> Resource<Order?> {
        let order = Order(vm)

        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect!")
        }

        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order!")
        }

        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = data

        return resource
    }

}
