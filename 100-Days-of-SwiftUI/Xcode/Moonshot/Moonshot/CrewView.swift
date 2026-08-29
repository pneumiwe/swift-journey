//
//  CrewView.swift
//  Moonshot
//
//  Created by Tarannum on 29/08/26.
//

import SwiftUI

struct CrewView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Crew")
                .font(.title.bold())
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(crew, id: \.role) { crewMember in
                        NavigationLink {
                            AstronautView(astronaut: crewMember.astronaut)
                        } label: {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 104, height: 72)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .strokeBorder(.white.opacity(0.2), lineWidth: 2)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .foregroundStyle(.white)
                                    
                                    Text(crewMember.role)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                        }
                        .padding(.trailing)
                    }
                }
            }
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

struct CrewView_Previews: PreviewProvider {
    static var previews: some View {
        let missions: [Mission] = Bundle.main.decode("missions.json")
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        
        return CrewView(mission: missions[5], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}
