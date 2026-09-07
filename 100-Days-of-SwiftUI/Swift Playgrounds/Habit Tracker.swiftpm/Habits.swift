import Foundation

@Observable
class Habits {
    var habits = [Habit]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    init() {
        if let savedHabits = UserDefaults.standard.data(forKey: "Habits") {
            if let decoded = try? JSONDecoder().decode([Habit].self, from: savedHabits) {
                habits = decoded
                return
            }
        }
        habits = []
    }
}

struct Habit: Identifiable, Codable {
    var id = UUID()
    let name: String
    let description: String
}
