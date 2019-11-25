//
//  AddCoffeeOrderViewModel.swift
//  HotCoffe
//
//  Created by Fabio Quintanilha on 11/25/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes : [String] {
        return CoffeSize.allCases.map { $0.rawValue.capitalized}
    }
    
    var numOfSections: Int {
        return 1
    }
    
    var numOfRows: Int {
        return self.types.count
    }
}
