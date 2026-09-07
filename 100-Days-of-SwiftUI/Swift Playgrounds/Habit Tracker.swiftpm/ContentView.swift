import SwiftUI

struct ContentView: View {
    @State private var habits = Habits()
    @State private var isShowingAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits.habits) { habit in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(habit.name)
                                .font(.headline)
                                
                            Text(habit.description)
                                .font(.caption)
                        }
                        Spacer()
                    }    
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("Habits")
            .sheet(isPresented: $isShowingAddView) {
                NavigationStack {
                    AddView(habits: habits)
                }
            }
            .toolbar {
                Button("New Habit", systemImage: "plus") {
                    isShowingAddView = true
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        habits.habits.remove(atOffsets: offsets)
    }
}
