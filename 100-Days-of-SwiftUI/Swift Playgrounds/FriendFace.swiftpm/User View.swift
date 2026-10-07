import SwiftUI

struct UserView: View {
    var user: User
    
    var body: some View {
        Form {
            Section("Registered") {
                Text(user.registered.formatted(date: .long, time: .omitted))
            }
            
            Section("Age") {
                Text(user.age.formatted())
            }
            
            Section("Company") {
                Text(user.company)
            }
            
            Section("Email") {
                Text(user.email)
            }
            
            Section("Address") {
                Text(user.address)
            }
            
            Section("About") {
                Text(user.about)
            }
            
            Section("Friends") {
                ForEach(user.friends) { friend in
                    Text(friend.name)
                }
            }
        }
        .navigationTitle(user.name)
        .navigationSubtitle(user.isActive ? "Active" : "Inactive")
    }
}
