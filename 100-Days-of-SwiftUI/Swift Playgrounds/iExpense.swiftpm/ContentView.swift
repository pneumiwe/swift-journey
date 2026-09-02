import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class PersonalExpenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Personal")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Personal") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

@Observable
class BusinessExpenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Business")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Business") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var personalExpenses = PersonalExpenses()
    @State private var businessExpenses = BusinessExpenses()
    @State private var showingAddExpense = false
    @State private var currentView = "Personal"
    
    let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Type", selection: $currentView) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } 
                
                ForEach(currentView == "Personal" ? personalExpenses.items : businessExpenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                        }
                        
                        Spacer()
                    
                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundStyle(item.amount >= 100 ? .red : item.amount <= 10 ? .green : .primary)
                    }
                }
                .onDelete(perform: removeItems)
            }
            
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink(value: 1) {
                    Image(systemName: "plus")
                }
                .navigationDestination(for: Int.self) { _ in
                    AddView(personalExpenses: personalExpenses, businessExpenses: businessExpenses)
                }
            }
        }
    }
    func removeItems(at offsets: IndexSet) {
        if currentView == "Personal" {
            personalExpenses.items.remove(atOffsets: offsets)
        } else {
            businessExpenses.items.remove(atOffsets: offsets)
        }
    }
}

