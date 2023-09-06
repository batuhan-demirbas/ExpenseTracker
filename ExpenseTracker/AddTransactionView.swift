//
//  AddTransactionView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 23.08.2023.
//

import SwiftUI

struct AddTransactionView: View {
    
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State var photoData: Data?
    
    let currentDate = Date()
    
    @State private var shouldPresentPhotoPicker = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section("information") {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, in: ...currentDate, displayedComponents: [.date])
                    NavigationLink(destination: Text("TEST")) {
                        Text("Many to many")
                    }
                    
                }
                
                Section("photo/receipt") {
                    Button {
                        shouldPresentPhotoPicker.toggle()
                    } label: {
                        Text("Select Photo")
                        
                        if let data = photoData, let image = UIImage.init(data: data){
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker) {
                        PhotoPickerView(photoData: $photoData)
                    }
                    
                }
                
            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: addTransactionButton)
        }
    }
    
    private var addTransactionButton: some View {
        Button("Save") {
            let context = PersistenceController.shared.container.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = self.name
            transaction.amount = Float(self.amount) ?? 0.0
            transaction.photoData = self.photoData
            transaction.timestamp = self.date
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to save transaction: \(error)")
            }
            
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
    
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
