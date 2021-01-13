//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by Kyungmin Lee on 2021/01/14.
//

import Foundation

class BankClerk {
    enum Task {
        case executeDeposit
        case reviewLoanDocument
        case executeLoan
        
        var time: TimeInterval {
            switch self {
            case .executeDeposit:
                return 0.7
            case .reviewLoanDocument:
                return 0.3
            case .executeLoan:
                return 0.3
            }
        }
    }
    
    // MARK: - Properties
    private let bankHeadOffice: BankHeadOffice
    private(set) var bankWindowNumber: Int
    private(set) var currentClient: Client?
    var isWorking: Bool {
        currentClient != nil
    }
    private(set) var finishedClients: Int = 0
    private let taskTime: Dictionary<Task, TimeInterval> = [.executeDeposit: 0.7, .reviewLoanDocument: 0.3, .executeLoan: 0.3]
    
    // MARK: - Methods
    func startWork(for client: Client) {
        currentClient = client
        print("\(client.tag)번 \(client.priority.string)고객 \(client.bankBusiness.string)업무 시작")
        
        switch client.bankBusiness {
        case .deposit:
            executeDeposit()
        case .loan:
            reviewLoanDocument()
        }
    }
    
    private func finishWork() {
        finishedClients += 1
        if let client = currentClient {
            print("\(client.tag)번 \(client.priority.string)고객 \(client.bankBusiness.string)업무 완료")
        }
        currentClient = nil
    }
    
    private func executeDeposit() {
        DispatchQueue.global().asyncAfter(deadline: .now() + Task.executeDeposit.time) {
            self.finishWork()
        }
    }
    
    private func reviewLoanDocument() {
        DispatchQueue.global().asyncAfter(deadline: .now() + Task.reviewLoanDocument.time) {
            self.requestLoan()
        }
    }
    
    private func requestLoan() {
        bankHeadOffice.addJudgementLoan(self)
    }
    
    func executeLoan() {
        DispatchQueue.global().asyncAfter(deadline: .now() + Task.executeLoan.time) {
            self.finishWork()
        }
    }
        
    init(_ bankHeadOffice: BankHeadOffice, _ bankWindowNumber: Int) {
        self.bankHeadOffice = bankHeadOffice
        self.bankWindowNumber = bankWindowNumber
    }
}
