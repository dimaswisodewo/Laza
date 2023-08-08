//
//  ProductBrandViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import Foundation

class ProductBrandViewModel {
    
    private(set) var brandName: String = ""
    
    typealias Products = [Product]
    private var products = Products()
    var productsCount: Int {
        return products.count
    }
    
    init(brandName: String, products: Products) {
        self.brandName = brandName
        self.products = products
    }
    
    func getProductOnIndex(index: Int) -> Product? {
        if index > productsCount - 1 {
            return nil
        }
        return products[index]
    }
}
