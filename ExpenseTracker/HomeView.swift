//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 31.07.2023.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @State private var shouldPresentAddCardForm = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CardView(card: card)
                        }
                    }
                    .frame(height: 280)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                    TransactionListView()                    
                    
                } else {
                    emptyPromptMessage
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        NewCardFormView()
                    }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: HStack{
                Button("Add Item", action: {
                    //deleteAllCards()
                })
                Button("Delete", action: {
                    deleteAllCards()
                })
            },trailing: addCardButton)
            
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .font(.system(size: 14, weight: .bold))
                .background(Color.black)
                .cornerRadius(5)
                .foregroundColor(Color.white)
            
        })
    }
    
    private func deleteAllCards() {
        withAnimation {
            let allOffsets = IndexSet(integersIn: 0..<cards.count)
            allOffsets.map { cards[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private var emptyPromptMessage: some View {
        VStack(spacing: 20) {
            Text("You currently have no cards in the system")
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
            Button("+ Add your first card") {
                shouldPresentAddCardForm.toggle()
            }
            .buttonStyle(.borderedProminent)
            .accentColor(.black)
        }
        .padding(40)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        HomeView()
            .environment(\.managedObjectContext, context)
    }
}
