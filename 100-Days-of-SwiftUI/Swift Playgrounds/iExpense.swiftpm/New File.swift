//
//import SwiftData
//import SwiftUI
//
//enum ShowOptions {
//    case personal, business, all
//}
//
//struct ContentView: View {
//    @Environment(\.modelContext) var modelContext
//    @Query var items: [ExpenseItem]
//    
//    @State private var sortOrder = [
//        SortDescriptor(\ExpenseItem.name),
//        SortDescriptor(\ExpenseItem.amount)
//    ]
//    @State private var filterSelection: ShowOptions = .all
//    @State private var showSelection = "Personal"
//    let filterOptions = ["Personal", "Business", "All"]
//    
//    var body: some View {
//        NavigationStack {
//            ItemsView(showing: filterSelection, sortOrder: sortOrder)
//                .navigationTitle("iExpense")
//                .toolbar {
//                    NavigationLink(value: 1) {
//                        Image(systemName: "plus")
//                    }
//                    
//                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
//                        Picker("Sort", selection: $sortOrder) {
//                            Text("Sort by Name")
//                                .tag([
//                                    SortDescriptor(\ExpenseItem.name),
//                                    SortDescriptor(\ExpenseItem.amount)
//                                ])
//                            
//                            Text("Sort by Amount")
//                                .tag([
//                                    SortDescriptor(\ExpenseItem.amount),
//                                    SortDescriptor(\ExpenseItem.name)
//                                ])
//                        }
//                        
//                        Picker("Filter", selection: $showSelection) {
//                            ForEach(filterOptions, id: \.self) {
//                                Text($0)
//                            }
//                        }
//                    }
//                }
//                .navigationDestination(for: Int.self) { _ in
//                    AddView()
//                }
//        }
//    }
//    
//    func deleteItems(at offsets: IndexSet) {
//        for offset in offsets {
//            let item = items[offset]
//            modelContext.delete(item)
//        }
//    }
//}
//
//struct ItemsView: View {
//    @Query var items: [ExpenseItem]
//    
//    var body: some View {
//        List(items) { item in
//            HStack {
//                Text(item.name)
//                    .font(.headline)
//                
//                Spacer()
//                
//                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
//                    .foregroundStyle(item.amount >= 100 ? .red : item.amount <= 10 ? .green : .primary)
//            }
//        }
//    }
//    
//    init(showing: ShowOptions, sortOrder: [SortDescriptor<ExpenseItem>]) {
//        _items = switch showing {
//        case .personal:
//            Query(filter: #Predicate<ExpenseItem> { item in
//                return item.type == "Personal"
//            }, sort: sortOrder)
//            
//        case .business:
//            Query(filter: #Predicate<ExpenseItem> { item in
//                return item.type == "Business"
//            }, sort: sortOrder)
//            
//        case .all:
//            Query(filter: #Predicate<ExpenseItem> { item in
//                return true
//            }, sort: sortOrder)
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
