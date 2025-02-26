//
//  AddTransactionRequest.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 20/02/25.
//

import Foundation

struct AddTransactionRequest {
    let categoryId: UUID?
    let title: String?
    let amount: String?
    let description: String?
    let date: String?
    let isIncome: Bool
}
