import Cocoa

// Challenge 8

// Make a protocol that describes a building, adding various properties and methods, then create two structs, House and Office, that conform to it. Your protocol should require the following:

// A property storing how many rooms it has.
// A property storing the cost as an integer (e.g. 500,000 for a building costing $500,000.)
// A property storing the name of the estate agent responsible for selling the building.
// A method for printing the sales summary of the building, describing what it is along with its other properties.

protocol Building {
    var numberOfRooms: Int { get }
    var cost: Int { get }
    var estateAgentName: String { get }
    
    func printSummary()
}


struct House: Building {
    var numberOfRooms: Int
    var cost: Int
    var estateAgentName: String
    
    func printSummary() {
        print("This is a house with \(numberOfRooms) rooms, sold by \(estateAgentName) for $\(cost)")
    }

}

struct Office: Building {
    var numberOfRooms: Int
    var cost: Int
    var estateAgentName: String
    
    func printSummary() {
        print("This is an office with \(numberOfRooms) rooms, sold by \(estateAgentName) for $\(cost)")
    }
}

let nycOffice = Office(numberOfRooms: 10, cost: 200_000, estateAgentName: "Smith & Co.")

nycOffice.printSummary()
