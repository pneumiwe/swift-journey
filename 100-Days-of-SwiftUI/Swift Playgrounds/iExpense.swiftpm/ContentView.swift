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

#Preview {
    ContentView()
}
