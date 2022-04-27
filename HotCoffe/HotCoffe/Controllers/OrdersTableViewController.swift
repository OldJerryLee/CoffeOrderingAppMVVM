//
//  OrderTableViewController.swift
//  HotCoffe
//
//  Created by Fabricio Pujol on 23/04/22.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController, AddCoffeOrderDelegate {
    var orderListViewModel = OrderListViewModel()

    //https://warp-wiry-rugby.glitch.me/clear-orders
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }

    private func populateOrders() {
        Webservice().load(resource: Order.all) { [weak self] result in
            switch result {
            case .success(let orders):
                print(orders)
                self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addCoffeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
            fatalError("error performing segue!")
        }

        addCoffeOrderVC.delegate = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)

        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size

        return cell
    }

    func addCoffeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)

        let orderVM = OrderViewModel(order:order)
        self.orderListViewModel.ordersViewModel.append(orderVM)

        self.tableView.insertRows(at: [IndexPath(row: self.orderListViewModel.ordersViewModel.count-1, section: 0)], with: .automatic)
    }

    func addCoffeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
