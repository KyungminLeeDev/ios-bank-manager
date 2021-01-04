//
//  Banker.swift
//  BankManagerConsoleApp
//
//  Created by Zero DotOne on 2021/01/05.
//

import Foundation

struct Banker {
    private var takesTimeOfBusiness = 0.7
    
    func doBusiness() {
        Thread.sleep(forTimeInterval: takesTimeOfBusiness)
    }
}
