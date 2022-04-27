//
//  AddOrderViewController.swift
//  HotCoffe
//
//  Created by Fabricio Pujol on 23/04/22.
//

import Foundation
import UIKit

protocol AddCoffeOrderDelegate {
    func addCoffeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    var delegate: AddCoffeOrderDelegate?

    private var vm = AddCoffeOrderViewModel()
    private var coffeSizesSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        self.coffeSizesSegmentedControl = UISegmentedControl(items: vm.sizes)
        self.coffeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(coffeSizesSegmentedControl)

        self.coffeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    @IBAction func close(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.addCoffeOrderViewControllerDidClose(controller: self)
        }
    }


    @IBAction func save(_ sender: Any) {
        let name = nameTextField.text
        let email = emailTextField.text

        let selectedSize = self.coffeSizesSegmentedControl.titleForSegment(at: self.coffeSizesSegmentedControl.selectedSegmentIndex)

        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffe!")
        }

        self.vm.name = name
        self.vm.email = email

        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]

        Webservice().load(resource: Order.create(vm: self.vm)) { result in
            switch result {
                case .success(let order):
                    if let order = order, let delegate = self.delegate {
                        DispatchQueue.main.async {
                            delegate.addCoffeOrderViewControllerDidSave(order: order, controller: self)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }

}

extension AddOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

extension AddOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeTypeTableViewCell", for: indexPath)

        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
    }
}
