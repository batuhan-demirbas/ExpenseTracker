//
//  NewCardFormView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 1.08.2023.
//

import SwiftUI

struct NewCardFormView: View {
    
    let card: Card?
    
    init(card: Card? = nil) {
        self.card = card
        
        _name = State(initialValue: card?.name ?? "")
        _number = State(initialValue: card?.number ?? "")
        _type = State(initialValue: card?.type ?? "")
        _month = State(initialValue: card?.month ?? "")
        _year = State(initialValue: Int(card?.year ?? 2023))
        
        if let colorData = card?.color {
            let cardUIColor = UIColor.decode(from: colorData)
            
            _color =  State(initialValue: Color(cardUIColor ?? .blue))
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var number = ""
    @State private var limit = ""
    @State private var type = "Visa"
    @State private var month = "01"
    @State private var year = 2023
    @State private var color = Color.blue
    
    private var types = ["Visa", "Master"]
    private var months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    private var years = Array(2023...2050)
    
    private var viewContext = PersistenceController.shared.container.viewContext
    
    var body: some View {
        NavigationView {
            Form {
                Section("card information") {
                    TextField("Name", text: $name)
                    TextField("Credit Card Number", text: $number)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                }
                
                Section("expiration") {
                    HStack(spacing: 50) {
                        Picker("Month", selection: $month) {
                            ForEach(months, id: \.self) { month in
                                Text(month)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Picker("Year", selection: $year) {
                            ForEach(years, id: \.self) { year in
                                Text(String(year))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Section("color") {
                    ColorPicker("Select a color", selection: $color)
                }
                
            }
            .navigationTitle(navTitle)
            .navigationBarItems(leading: cancelButton, trailing: saveCardButton)
        }
    }
    
    var navTitle: String {
        if card != nil {
            return card?.name ?? ""
        } else {
            return "Add Credit Card"
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
    
    var saveCardButton: some View {
        Button {
            addCard()
        } label: {
            Text("Save")
        }
        .buttonStyle(.borderedProminent)
        
    }
    
    private func addCard() {
        withAnimation {
            let card = self.card != nil ? self.card! : Card(context: viewContext)
            
            card.timestamp = Date()
            card.name = name
            card.number = number
            card.type = type.lowercased()
            card.month = month
            card.year = Int16(year)
            card.limit = Int32(limit) ?? 00
            card.color = UIColor(color).encode()
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }
    }
    
}

struct NewCardFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewCardFormView()
    }
}
