//
//  ServiceManagerProtocol.swift
//  News
//
//  Created by Moin Uddin on 5/3/2023.
//

protocol ServiceManagerProtocol {
    var isServiceAvailable: Bool { get }
    
    func setServiceNotAvailable()
    
    func setServiceAvailable()
}
