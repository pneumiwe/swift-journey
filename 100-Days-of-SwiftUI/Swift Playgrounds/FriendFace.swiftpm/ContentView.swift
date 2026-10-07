import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    @State private var activeUsers: Int
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink {
                    UserView(user: user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        
                        HStack {
                            Circle()
                                .foregroundStyle(user.isActive ? .green : .secondary)
                                .frame(width: 10, height: 10)
                            
                            Text(user.isActive ? "Active" : "Inactive")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Friend Face")
            .task {
                if users.isEmpty {
                    await loadData()
                }
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedUsers = try decoder.decode([User].self, from: data)
            users = decodedUsers
        } catch {
            print("Invalid Data")
        }
        
    
    }
}
