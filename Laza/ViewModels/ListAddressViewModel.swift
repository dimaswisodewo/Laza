//
//  ListAddressViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 17/08/23.
//

import Foundation

class ListAddressViewModel {
    
    private var address = [Address]()
    var addressCount: Int { return address.count }
    
    func getAddressAtIndex(index: Int) -> Address {
        if index >= address.count {
            fatalError("Index out of bounds")
        }
        return address[index]
    }
    
    func configure(address: [Address]) {
        self.address = address
    }
    
    func addNewAddress(newAddress: Address) {
        address.append(newAddress)
    }
}
