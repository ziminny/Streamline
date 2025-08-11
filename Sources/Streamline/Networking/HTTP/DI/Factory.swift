//
//  Factory.swift
//  AppAuth
//
//  Created by vagner reis on 01/10/24.
//

import Foundation

@propertyWrapper
public struct Factory<Service: ServiceProtocol> {
    
    private var service: Service?
    private var instanceType: InstanceType
    private let factory: any HTTPServiceFactoryProtocol
    
    public init(
        instanceType: InstanceType = .Singleton,
        factory: any HTTPServiceFactoryProtocol = HTTPServiceFactory()
    ) {
        self.instanceType = instanceType
        self.factory = factory
    }
    
    public var wrappedValue: Service {
        
        mutating get {
            
            if instanceType == .NewInstance {
                service = Service(withFactory: factory)
                return service!
            }
            
            let retainInstance = RetainInstance<Service>(factory: factory)
            let contain = retainInstance(contains: Service.self)
          
            if contain == nil {
                let inserted = retainInstance(append: Service.self)
                service = inserted
            } else {
                service = contain
            }
            
            return service!
            
        } set {
            service = newValue
        }
        
    }
    
}

@dynamicCallable
fileprivate struct RetainInstance<Service: ServiceProtocol> {
    
    private let factory: any HTTPServiceFactoryProtocol
    
    init(factory: any HTTPServiceFactoryProtocol) {
        self.factory = factory
    }
        
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Service.Type>) -> Service? {
        
        for (key,_) in args {
            if key == "contains" {
                return StorageInstence.shared.get(ofType: Service.self)
            }
            if key == "append" {
                let service = Service(withFactory: factory)
                StorageInstence.shared.append(service)
                return service
            }
        }
        
        return nil
    }
    
}

fileprivate final class StorageInstence: Sendable {
    
    static nonisolated(unsafe) var shared = StorageInstence()
    
    static nonisolated(unsafe) private(set) var instances: [any ServiceProtocol] = []
    
    private let privateQueue: DispatchQueue = DispatchQueue(label: "com.passiOAB.Factory", attributes: .concurrent)
    
    func append(_ item: any ServiceProtocol) {
        privateQueue.async(flags: .barrier) {
            StorageInstence.instances.append(item)
        }
    }
    
    func get<Service: ServiceProtocol>(ofType: Service.Type) -> Service? {
        return privateQueue.sync {
            return StorageInstence.instances.first { $0 is Service } as? Service
        }
    }
}
