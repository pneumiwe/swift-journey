import Foundation

struct UserAddress: Codable {
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _userAddress = "userAddress"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    var hasValidAddress: Bool {
        if userAddress.name.containsOnlyWhiteSpaces() || 
            userAddress.streetAddress.containsOnlyWhiteSpaces() || 
            userAddress.city.containsOnlyWhiteSpaces() || 
            userAddress.zip.containsOnlyWhiteSpaces() 
        {
            return false
        }
        return true
    }
    
    var userAddress: UserAddress {
        didSet {
            if let encoded = try? JSONEncoder().encode(userAddress) {
                UserDefaults.standard.set(encoded, forKey: "UserAddress")
            }
        }
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        
        cost += Decimal(type) / 2
        
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity)
        }
        
        return cost
    }
    
    init() {
        if let address = UserDefaults.standard.data(forKey: "UserAddress") {
            if let decodedItems = try? JSONDecoder().decode(UserAddress.self, from: address) {
                userAddress = decodedItems
                return
            }
        }
        userAddress = UserAddress()
    }
}

extension String {
    func containsOnlyWhiteSpaces() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
