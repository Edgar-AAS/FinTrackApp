//
//  AlertViewModel.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 13/02/25.
//

public struct AlertViewModel: Equatable {
    public let title: String
    public let message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
