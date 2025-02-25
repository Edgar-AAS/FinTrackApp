//
//  AddTransactionRequest.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 20/02/25.
//

import Foundation

struct AddTransactionRequest {
    let categoryId: UUID
    let title: String
    let amount: Double
    let description: String?
    let date: String
    let transactionTitle: String
    let isIncome: Bool
}
