//
//  OrderViewModel.swift
//  HotCoffe
//
//  Created by Fabio Quintanilha on 11/25/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import Foundation

class OrderListViewModel {
    var ordersViewModel: [OrderViewModel]
    
    init() {
        self.ordersViewModel = [OrderViewModel]()
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfOrders: Int {
        return ordersViewModel.count
    }
    
    func orderAtIndex(at index: Int) -> OrderViewModel {
        return self.ordersViewModel[index]
    }
}

struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    var name: String {
        return self.order.name
    }
    
    var email: String {
        return self.order.email
    }
    
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}
