import Foundation

extension Double {
    public func formatToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencySymbol = "R$"
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(for: self) ?? "Não foi possível mostrar o saldo"
    }
}
