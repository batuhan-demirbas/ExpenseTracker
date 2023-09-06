//
//  CardTransactionView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 6.09.2023.
//

import SwiftUI

struct CardTransactionView: View {
    
    init(_ transaction: CardTransaction) {
        self.transaction = transaction
    }
    
    @Environment(\.managedObjectContext) private var viewContext

    private let transaction : CardTransaction
    
    @State private var shouldShowDeleteTransaction = false

    var body: some View {
        VStack(alignment: .leading) {
            VStack{
                HStack{
                    Text(transaction.name ?? "")
                    Spacer()
                    Button {
                        shouldShowDeleteTransaction.toggle()
                    } label: {
                        Text("...")
                    }
                    .actionSheet(isPresented: $shouldShowDeleteTransaction) {
                        .init(title: Text(transaction.name ?? ""), message: Text("Are you sure the transaction will be deleted?"), buttons: [
                            .default(Text("Edit"), action: { handleEditTransaction() }),
                            .destructive(Text("Delete Transaction"), action: { handleDeleteTransaction(transaction) }),
                            .cancel()
                        ])
                    }
                    
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                
                HStack{
                    if let formattedDate = formatDate(transaction.timestamp) {
                        Text(formattedDate)
                    }
                    Spacer()
                    Text("$500.00")
                    
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            }
            
            Image("visa")
                .resizable()
                .scaledToFit()
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
        )
        .padding(12)

    }
    
    private func handleDeleteTransaction(_ transaction: CardTransaction) {
        withAnimation {
            do {
                viewContext.delete(transaction)
                try viewContext.save()
            } catch {
                print("Failed to delete transaction: \(error)")
            }
        }
    }
    
    private func handleEditTransaction() {
        
    }
    
    func formatDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter.string(from: date)
    }
}

/*
struct CardTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        CardTransactionView()
    }
}
*/
