//
//  AddOrderViewController.swift
//  HotCoffe
//
//  Created by Fabio Quintanilha on 11/23/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    private var viewModel = AddCoffeeOrderViewModel()
    var delegate: AddCoffeeOrderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupUI()
    }
    
    private func setupUI() {
        self.segmentedControl.backgroundColor = UIColor.cyan
        var segmentIndex = 0
        for size in self.viewModel.sizes {
            if (segmentIndex < self.segmentedControl.numberOfSegments) {
                self.segmentedControl.setTitle(size, forSegmentAt: segmentIndex)
            }
            else {
                self.segmentedControl.insertSegment(withTitle: size, at: segmentIndex, animated: true)
            }
            segmentIndex += 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numOfSections
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.viewModel.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func save() {
        let name = self.nameTextField.text ?? ""
        let email = self.emailTextField.text ?? ""
        
        let selectedSize = self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error selecting coffee!")
        }
        
        self.viewModel.email = email
        self.viewModel.name = name
        
        self.viewModel.selectedSize = selectedSize
        self.viewModel.selectedType = self.viewModel.types[indexPath.row]
        
        Webservice().load(resource: Order.create(viewModel: self.viewModel)) { (result) in
            switch result {
            case .success(let order):
                if let order = order, let delagate = self.delegate {
                    DispatchQueue.main.async {
                        delagate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func close() {
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
    }

}
