//
//  BankManagerConsoleApp - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import Foundation

while true {
    print("1: 은행 개점")
    print("2: 종료")
    print("입력: ", terminator: "")
    
    let choice = readLine()
    if choice == "1" {
        var banker = BankManager()
        banker.open(banker: 1)
        banker.greetingCustomer(number: Int.random(in: 10...30))
        banker.process()
    } else if choice == "2" {
        break
    } else {
        print("잘못 입력하셨습니다. 다시 입력해주세요.")
    }
}
