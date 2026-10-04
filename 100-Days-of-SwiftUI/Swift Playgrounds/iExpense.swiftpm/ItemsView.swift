import SwiftData
import SwiftUI

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
