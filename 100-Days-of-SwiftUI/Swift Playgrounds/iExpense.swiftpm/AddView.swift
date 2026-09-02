import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var personalExpenses: PersonalExpenses
    var businessExpenses: BusinessExpenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
            
            TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
        }
        .navigationTitle("Add new expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if name.count < 1 {
                        return
                    }
                    if type == "Personal" {
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        personalExpenses.items.append(item)
                        dismiss()
                    } else {
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        businessExpenses.items.append(item)
                        dismiss()
                    }
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AddView(personalExpenses: PersonalExpenses(), businessExpenses: BusinessExpenses())
}
