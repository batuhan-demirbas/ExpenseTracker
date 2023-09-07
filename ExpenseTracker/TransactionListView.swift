//
//  TransactionListView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 6.09.2023.
//

import SwiftUI

struct TransactionListView: View {
    let card: Card
    
    init(card: Card) {
        self.card = card
        
        transactionFetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(),
                                                     sortDescriptors: [.init(key: "timestamp", ascending: false)],
                                                     predicate: NSPredicate(format: "card == %@", card))
        
    }
    
    
    private var transactionFetchRequest: FetchRequest<CardTransaction>
    
    @State private var shouldShowAddTransactionForm = false
    
    var body: some View {
        
        let transactions = transactionFetchRequest.wrappedValue
        
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
            AddTransactionView(card: self.card)
        }
    }
    
}

/*
 struct TransactionListView_Previews: PreviewProvider {
 static var previews: some View {
 TransactionListView(card: self.card)
 }
 }
 */
