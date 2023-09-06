//
//  TransactionListView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 6.09.2023.
//

import SwiftUI

struct TransactionListView: View {
        
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
    @State private var shouldShowAddTransactionForm = false
    
    var body: some View {
        
        if transactions.isEmpty {
            Text("Get started by adding your first transaction")
            addTransactionButton
        } else {
            HStack {
                Spacer()
                addTransactionButton
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
            
            ForEach(transactions) { transaction in
                CardTransactionView(transaction)
            }
            
        }
        
    }
    
    var addTransactionButton: some View {
        Button("+ Transaction") {
            shouldShowAddTransactionForm.toggle()
        }
        .buttonStyle(.borderedProminent)
        .accentColor(.black)
        .sheet(isPresented: $shouldShowAddTransactionForm) {
            AddTransactionView()
        }
    }
    
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
