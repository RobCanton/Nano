//
//  BinarySearch.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-13.
//

import Foundation

func binarySearch<T: Comparable>(array: [T], value:T, greater:Bool) -> Int? {
    if let first = array.first, value < first {
        return nil
    }
    
    if let last = array.last, value > last {
        return nil
    }
    
    var left = 0
    var right = array.count - 1
    while left <= right {
        let middle = Int(floor(Double(left + right) / 2.0))
        
        if array[middle] == value {
            return middle
        } else if array[middle] <= value {
            left = middle + 1
        } else {// if array[middle] >= value {
            right = middle - 1
        }
    }
   
    if greater {
        return left
    } else {
        return right
    }
}
