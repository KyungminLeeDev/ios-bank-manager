//
//  Banker.swift
//  BankManagerConsoleApp
//
//  Created by Zero DotOne on 2021/01/05.
//

import Foundation

struct Banker {
    private var takesTimeOfBusiness = 0.7
    
    func doBusiness(_ tag: Int) {
        let tagNumber = tag + 1
        print("\(tagNumber)번 고객 업무 시작")
        Thread.sleep(forTimeInterval: takesTimeOfBusiness)
        print("\(tagNumber)번 고객 업무 종료")
    }
}
