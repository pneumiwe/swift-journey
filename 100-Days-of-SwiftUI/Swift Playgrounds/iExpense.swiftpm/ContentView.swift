import SwiftData
import SwiftUI

enum ShowOptions {
    case personal, business, all
}

struct ContentView: View {
    @Query var items: [ExpenseItem]
    
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ]
    @State private var filterSelection = "All"
    let filterOptions = ["Personal", "Business", "All"]
    
    var body: some View {
        NavigationStack {
            ItemsView(selection: filterSelection, sortOrder: sortOrder)
                .navigationTitle("iExpense")
                .toolbar {
                    NavigationLink(value: 1) {
                        Image(systemName: "plus")
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Name")
                                .tag([
                                    SortDescriptor(\ExpenseItem.name),
                                    SortDescriptor(\ExpenseItem.amount)
                                ])
                            
                            Text("Sort by Amount")
                                .tag([
                                    SortDescriptor(\ExpenseItem.amount),
                                    SortDescriptor(\ExpenseItem.name)
                                ])
                        }
                        
                        Picker("Filter", selection: $filterSelection) {
                            ForEach(filterOptions, id: \.self) {
                                Text("Show \($0)")
                            }
                        }
                    }
                }
                .navigationDestination(for: Int.self) { _ in
                    AddView()
                }
        }
    }
}

struct ItemsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [ExpenseItem]
    
    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        
                            Text(item.type)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(item.amount >= 100 ? .red : item.amount <= 10 ? .green : .primary)
                }
            }
            .onDelete(perform: deleteItems)
        }
        
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offset in offsets {
            let item = items[offset]
            modelContext.delete(item)
        }
    }
    
    init(selection: String, sortOrder: [SortDescriptor<ExpenseItem>]) {
        _items = Query(filter: #Predicate<ExpenseItem> { item in
            if selection == "Personal" {
                return item.type == "Personal"
            } else if selection == "Business" {
                return item.type == "Business"
            } else {
                return true
            }
        }, sort: sortOrder)
    }
}

#Preview {
    ContentView()
}
