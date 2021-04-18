//
//  MathExtension.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Foundation

public func valueIn<T>(_ value: T, min rangeMin: T, max rangeMax: T) -> T where T : Comparable {
    return min(max(rangeMin, value), rangeMax)
}

public func regular<T>(_ value: T, min rangeMin: T, max rangeMax: T) -> T where T : FloatingPoint {
    return (value - rangeMin) / (rangeMax - rangeMin)
}
