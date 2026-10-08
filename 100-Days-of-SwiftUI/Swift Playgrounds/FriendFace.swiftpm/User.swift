import Foundation
import SwiftData

struct UserStruct: Identifiable, Codable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [FriendStruct]
}

struct FriendStruct: Identifiable, Codable {
    let id: String
    let name: String
}

@Model
final class User {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
    
    init(from userStruct: UserStruct) {
        self.id = userStruct.id
        self.isActive = userStruct.isActive
        self.name = userStruct.name
        self.age = userStruct.age
        self.company = userStruct.company
        self.email = userStruct.email
        self.address = userStruct.address
        self.about = userStruct.about
        self.registered = userStruct.registered
        self.tags = userStruct.tags
        self.friends = userStruct.friends.map { Friend(from: $0) }
    }
}

@Model
final class Friend {
    var id: String
    var name: String
    
    init(from friendStruct: FriendStruct) {
        self.id = friendStruct.id
        self.name = friendStruct.name
    }
}
