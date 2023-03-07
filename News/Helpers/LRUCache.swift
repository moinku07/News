//
//  LRUCache.swift
//  News
//
//  Created by Moin Uddin on 4/3/2023.
//

import Foundation

public final actor LRUCache<Key: Hashable, Value> {
    /// Current total cost of the values in the cache.
    public private(set) var currentCost: Int = 0
    
    /// Current cache count.
    public var count: Int {
        return values.count
    }
    
    /// The maximum cost permtted.
    ///
    /// Cleans up oldest data when `currentCost` exceeds `maxCost` or cache count exeeds the `maxCount`.
    public private(set) var maxCost: Int = .max
    
    /// The maximum number of the cache permitted.
    ///
    /// Cleans up oldest data when `currentCost` exceeds `maxCost` or cache count exeeds the `maxCount`.
    public private(set) var maxCount: Int = .max
    
    /// Set/update the `maxCost`.
    public final func setMaxCost(_ maxCost: Int){
        self.maxCost = maxCost
    }
    
    /// Set/update the `maxCount`.
    public final func setMaxCount(_ maxCount: Int){
        self.maxCount = maxCount
    }
    
    /// Store all the Key, Value pair in memory.
    private var values: [Key: Container] = [:]
    
    public init(
        maxCost: Int = .max,
        maxCount: Int = .max
    ) {
        self.maxCost = maxCost
        self.maxCount = maxCount
    }
    
    deinit{
        print("\(type(of: self)) deinit.")
    }
}

private extension LRUCache {
    struct Container {
        var key: Key
        var value: Value
        var cost: Int
        let createdAt: Date = .now
        
        init(key: Key, value: Value, cost: Int) {
            self.key = key
            self.value = value
            self.cost = cost
        }
    }
    
    /// Removes old data when either current cache count exceeds the maximum cache count or current cache size exceeds the maximum cache size.
    func clean() {
        var sortedValues = values.sorted { $0.value.createdAt > $1.value.createdAt }
        while currentCost > maxCost || values.count > maxCount, let container = sortedValues.popLast()?.value {
            removeValue(forKey: container.key)
        }
    }
}

public extension LRUCache {
    /// Remove the associated value from the cache and returns the value.
    @discardableResult
    func removeValue(forKey key: Key) -> Value? {
        guard let container = values.removeValue(forKey: key) else {
            return nil
        }
        
        currentCost -= container.cost
        
        return container.value
    }
    
    /// Insert a value into the cache.
    func setValue(_ value: Value?, forKey key: Key, cost: Int = 0) {
        defer { clean() }
        
        var cost = cost
        
        guard let value = value else {
            removeValue(forKey: key)
            return
        }
        
        if var container = values[key] {
            cost = cost == 0 ? container.cost : cost
            currentCost -= cost
            
            container.value = value
            container.cost = cost
        } else {
            let container = Container(key: key, value: value, cost: cost)
            values[key] = container
        }
        
        currentCost += cost
    }
    
    /// Returns the value from the cache for the key.
    func value(forKey key: Key) -> Value? {
        guard let container = values[key] else {
            return nil
        }
        
        return container.value
    }
    
    /// Returns all values from the cache for the key.
    var allValues: [Value] {
        return values.map { $0.value.value }
    }
    
    /// Returns all items in the cache as key-value pair.
    var allKeyValues: [[Key: Value]] {
        return values.map { [$0.key: $0.value.value] }
    }
}
