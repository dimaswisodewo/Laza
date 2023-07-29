//
//  HomeViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class HomeViewModel {
    
    func logout() {
        DataPersistentManager.shared.deleteUserDataInUserDefaults()
    }
}
