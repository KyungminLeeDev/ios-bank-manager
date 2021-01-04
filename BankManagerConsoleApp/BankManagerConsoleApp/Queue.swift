//
//  Queue.swift
//  BankManagerConsoleApp
//
//  Created by Zero DotOne on 2021/01/05.
//

import Foundation

struct Queue<T> {
    private var data = [T]()
    
    mutating func enqueue(element: T) {
        return data.append(element)
    }
    
    mutating func dequeue() -> T? {
        if data.isEmpty {
            return nil
        } else {
            return data.removeFirst()
        }
    }
    
    mutating func peek() -> T? {
        return data.first
    }
    
    mutating func isEmpty() -> Bool {
        return data.isEmpty
    }
}
