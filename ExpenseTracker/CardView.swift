//
//  CardView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 31.07.2023.
//

import SwiftUI

struct CardView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var card: Card
    @State private var shouldShowActionSheet = false
    @State private var shouldShowEditForm = false
    @State private var refreshId = UUID()
    
    private func handleDelete() {
        viewContext.delete(card)
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting card: \(error)")
        }
    }
    
    private func handleEdit() {
        shouldShowEditForm.toggle()
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Text(card.name ?? "nil")
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
                Button {
                    shouldShowActionSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .bold))
                }
                .actionSheet(isPresented: $shouldShowActionSheet) {
                    .init(title: Text(card.name ?? ""), message: Text("Are you sure the card will be deleted?"), buttons: [
                        .default(Text("Edit"), action: { handleEdit() }),
                        .destructive(Text("Delete Card"), action: { handleDelete() }),
                        .cancel()
                    ])
                }
                
            }
            HStack(alignment: .center) {
                Image(card.type ?? "visa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                Spacer()
                Text("Balance: $\(card.balance)")
                    .font(.system(size: 18, weight: .semibold))
            }
            Text(card.number ?? "nil")
            //Text("\(card.month)/\(card.year)")
            Text("Limit: $\(card.limit)")
            HStack {Spacer()}
        }
        .foregroundColor(Color.white)
        .padding()
        .background(
            VStack {
                let colorData = card.color
                let uiColor = UIColor.decode(from: colorData ?? Data())
                let actualColor = Color(uiColor ?? UIColor(Color.blue))
                LinearGradient(colors: [actualColor, actualColor.opacity(0.5)], startPoint: .bottom, endPoint: .top)
                
            })
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 8)
        
        .fullScreenCover(isPresented: $shouldShowEditForm) {
            NewCardFormView(card: card)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let exampleCard = Card(context: context)
        exampleCard.name = "Example Card"
        exampleCard.type = "visa"
        exampleCard.number = "1234 5678 9012 3456"
        exampleCard.limit = 5000
        
        return CardView(card: exampleCard)
    }
}
