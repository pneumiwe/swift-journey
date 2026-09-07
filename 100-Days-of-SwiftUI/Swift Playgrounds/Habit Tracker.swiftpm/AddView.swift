import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    
    var habits: Habits
    
    var body: some View {
        List {
            TextField("Habit", text: $name)
            TextField("Description", text: $description)
        }
        .navigationTitle("New Habit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Done", systemImage: "checkmark") {
                if name.count < 1 {
                    dismiss()
                } else {
                    let newHabit = Habit(name: name, description: description)
                    habits.habits.append(newHabit)
                    dismiss()
                }
            }
        }
    }
}
