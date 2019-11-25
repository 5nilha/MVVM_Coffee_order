//
//  OrderTableViewController.swift
//  HotCoffe
//
//  Created by Fabio Quintanilha on 11/23/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, AddCoffeeOrderDelegate {
    
    
    
    var orderListViewModel = OrderListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders() {
    
        Webservice().load(resource: Order.all) { [weak self] (result) in
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
    
    // delegate fucntions of AddCoffeeOrderDelegate
    
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        let orderViewModel = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderViewModel)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.numberOfOrders - 1, section: 0)], with: .automatic)
        
    }
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
            let addCoffeeOrderVC = navController.viewControllers.first as? AddOrderViewController
            else {
                fatalError("Error performing segue!")
        }
        addCoffeeOrderVC.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.orderListViewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.numberOfOrders
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.orderListViewModel.orderAtIndex(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = viewModel.type
        cell.detailTextLabel?.text = viewModel.size
        return cell
    }
    

}
