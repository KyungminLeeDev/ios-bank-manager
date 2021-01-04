//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct BankManager {
    private var banker: [Banker]?
    private var numberOfCustomersVisitingTheBank = 0
    private var customer = Queue<Int>()
    
    mutating func open(banker: Int) {
        self.banker = [Banker](repeating: Banker(), count: banker)
        print("은행 개점했습니다.")
    }
    
    mutating func greetingCustomer(number: Int) {
        numberOfCustomersVisitingTheBank = number
        for customerTag in 0..<number {
            customer.enqueue(element: customerTag)
        }
    }
    
    mutating func process() {
        while let tag = customer.dequeue() {
            banker?[0].doBusiness(tag)
        }
        close()
    }
    
    private mutating func close() {
        banker = nil
        let takesTimeOfBusiness = 0.7
        let totalTakesTimeOfBusiness = Double(numberOfCustomersVisitingTheBank) * takesTimeOfBusiness
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(numberOfCustomersVisitingTheBank)명이며, 총 업무시간은 \(totalTakesTimeOfBusiness)초입니다.")
    }
}
