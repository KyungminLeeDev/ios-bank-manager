//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

enum BankBusiness: CaseIterable {
    case loan
    case deposit
    
    var string: String {
        switch self {
        case .loan:
            return "대출"
        case .deposit:
            return "예금"
        }
    }
}

private class BankClerk {
    // MARK: - Properties
    let bankHeadOffice: BankHeadOffice
    var bankWindowNumber: Int
    var isWorking: Bool {
        currentClient != nil
    }
    var currentClient: Client?
    var finishedClients: Int = 0
    
    // MARK: - Methods
    func startWork(for client: Client) {
        currentClient = client
        print("\(client.tag)번 \(client.priority.string)고객 \(client.bankBusiness.string)업무 시작")
        
        DispatchQueue.global().asyncAfter(deadline: workTime(bankBusiness: client.bankBusiness)) {
            self.finishWork()
        }
    }
    
    func finishWork() {
        finishedClients += 1
        if let client = currentClient {
            print("\(client.tag)번 \(client.priority.string)고객 \(client.bankBusiness.string)업무 완료")
        }
        currentClient = nil
    }
    
    func workTime(bankBusiness: BankBusiness) -> DispatchTime {
        switch bankBusiness {
        case .loan:
            return .now() + .milliseconds(1100)
        case .deposit:
            return .now() + .milliseconds(700)
        }
    }
    
    init(_ bankHeadOffice: BankHeadOffice, _ bankWindowNumber: Int) {
        self.bankHeadOffice = bankHeadOffice
        self.bankWindowNumber = bankWindowNumber
    }
}

struct BankManager {
    // MARK: - Properties
    private let bankHeadOffice: BankHeadOffice
    private var bankClerks: [BankClerk] = [BankClerk]()
    private var waitingClients: Queue<Client> = Queue<Client>()
    private var waitingTicketNumber: Int = 0
    private var startBusinessTime: Double = 0.0
    var currentBusinessTime: Double {
        CFAbsoluteTimeGetCurrent() - startBusinessTime
    }
    var totalBusinessTime: Double?
    var totalFinishedClients: Int {
        bankClerks.reduce(0) {
            $0 + $1.finishedClients
        }
    }
    var isAllBankClerkFinishWork: Bool {
        let waitingBankClerks = bankClerks.filter{$0.isWorking == false}
        return waitingBankClerks.count == bankClerks.count
    }
    
    // MARK: - Methods
    mutating func addBankClerk(count: Int) {
        guard count > 0 else {
            return
        }
        
        let lastCounterNumber = bankClerks.last?.bankWindowNumber ?? 0
        for i in 1...count {
            let bankClerk = BankClerk(bankHeadOffice, i + lastCounterNumber)
            bankClerks.append(bankClerk)
        }
    }
    
    mutating func addClient(count: Int) {
        guard count > 0 else {
            return
        }
        
        for _ in 1...count {
            waitingTicketNumber += 1
            waitingClients.enqueue(element: Client(tag: waitingTicketNumber))
        }
    }
    
    mutating func doBusiness() {
        startBusiness()
        makeBankClerkWork()
        endBusiness()
    }
    
    private mutating func startBusiness() {
        startBusinessTime = CFAbsoluteTimeGetCurrent()
    }
    
    private mutating func endBusiness() {
        totalBusinessTime = currentBusinessTime
        printWorkEndMessage()
    }
    
    private mutating func makeBankClerkWork() {
        while true {
            if waitingClients.isEmpty && isAllBankClerkFinishWork {
                break
            } else {
                startBankClerkWork()
            }
        }
    }
    
    private mutating func startBankClerkWork() {
        let waitBankClerks = bankClerks.filter{$0.isWorking == false}
        for waitBankClerk in waitBankClerks {
            if let client = waitingClients.dequeue() {
                waitBankClerk.startWork(for: client)
            }
        }
    }
    
    private func printWorkEndMessage() {
        let totalBusinessTimeString = String(format: "%.2f", totalBusinessTime ?? 0)
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(totalFinishedClients)명이며, 총 업무시간은 \(totalBusinessTimeString)초입니다")
    }
    
    init(_  bankHeadOffice: BankHeadOffice, _ numberOfBankClerk: Int, _ numberOfClient: Int) {
        self.bankHeadOffice = bankHeadOffice
        addBankClerk(count: numberOfBankClerk)
        addClient(count: numberOfClient)
    }
}
