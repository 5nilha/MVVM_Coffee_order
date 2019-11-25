//
//  Order.swift
//  HotCoffe
//
//  Created by Fabio Quintanilha on 11/24/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappucino
    case latte
    case espressino
    case cortado
}

enum CoffeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
    case xlarge
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeSize
    
    init?(_ viewModel: AddCoffeeOrderViewModel) {
        guard let name = viewModel.name,
            let email = viewModel.email,
            let selectedType = CoffeeType(rawValue: viewModel.selectedType!.lowercased()),
            let selectedSize = CoffeSize(rawValue: viewModel.selectedSize!.lowercased())
            else {
                return nil
        }
        
        self.name = name
        self.email = email
        self.size = selectedSize
        self.type = selectedType
    }
}

extension Order {
    
    static var all: Resource<[Order]> = {
         guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect")
        }
        return Resource<[Order]>(url: url)
    }()
    
    
    static func create(viewModel: AddCoffeeOrderViewModel) -> Resource<Order?> {
        let order = Order(viewModel)
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("URL is incorrect")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("error encoding order!")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        return resource
    }
}
