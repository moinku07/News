//
//  ServiceManager.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation
import Network

class ServiceManager: ServiceManagerProtocol{
    static var shared:  ServiceManager = ServiceManager()
    
    private init(){}
    
    private var queqe = DispatchQueue(label: "ServiceManager Queue", attributes: .concurrent)
    
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
    
    func startNetworkMonitoring(){
        networkMonitor.start(queue: networkMonitorQueue)
    }
    
    func stopNetworkMonitoring(){
        networkMonitor.cancel()
    }
    
    /// A dispatch queue to be used for NWPathMonitor.
    let networkMonitorQueue = DispatchQueue(label: "NetworkMonitorQueue")
    
    private lazy var networkMonitor: NWPathMonitor = {
        let networkMonitor = NWPathMonitor()
        
        networkMonitor.pathUpdateHandler = {[weak self] path in
            if path.status == .satisfied{
                print("Reachable via \(path.availableInterfaces.map{"type: \($0.type), name: \($0.name)"}.joined(separator: ", "))")
                self?.setServiceAvailable()
            }else{
                print("Not reachable. Reason = \(path.unsatisfiedReason)")
                self?.setServiceNotAvailable()
            }
        }
    
        return networkMonitor
    }()
}
