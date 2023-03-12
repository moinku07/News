//
//  MockServiceManager.swift
//  NewsTests
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation
@testable import News

class MockServiceManager: ServiceManagerProtocol{
    static var shared:  MockServiceManager = MockServiceManager()
    
    private init(){}
    
    private var queqe = DispatchQueue(label: "MockServiceManager Queue", attributes: .concurrent)
    
    private var _isServiceAvailable: Bool = true
    
    var isServiceAvailable: Bool{
        get{
            return queqe.sync{
                return _isServiceAvailable
            }
        }
    }
    
    func setServiceNotAvailable() {
        queqe.async{[weak self] in
            self?._isServiceAvailable = false
        }
    }
    
    func setServiceAvailable() {
        queqe.async{[weak self] in
            self?._isServiceAvailable = true
        }
    }
}
