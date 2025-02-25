//
//  AddTransactionScreenViewModel.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 17/02/25.
//
import UIKit

struct AddTransactionScreenViewModel {
    let isIncome: Bool
    let dateAndTime: String
}

struct CategoryViewModel {
    let id: UUID
    let title: String
    
    init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}
