//
//  OrderTableViewController.swift
//  HotCoffe
//
//  Created by Fabricio Pujol on 23/04/22.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController {
    //https://warp-wiry-rugby.glitch.me/clear-orders
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }

    private func populateOrders() {
        guard let coffeOrdersURL = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL was incorrect")
        }

        let resource = Resource<[Order]>(url: coffeOrdersURL)

        Webservice().load(resource: resource) { result in
            switch result {
            case .success(let orders):
                print(orders)
            case .failure(let error):
                print(error)
            }
        }
    }
}
