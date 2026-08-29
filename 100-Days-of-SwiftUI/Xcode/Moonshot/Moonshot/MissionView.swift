//
//  MissionView.swift
//  Moonshot
//
//  Created by Tarannum on 28/08/26.
//

import SwiftUI

struct MissionView: View {
    let mission: Mission
    let astronauts: [String: Astronaut]
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Text(mission.displayName)
                    .font(.largeTitle.bold())
                
                Text("Launched: \(mission.formattedLaunchDate)")
                    .font(.caption)
                
                Rectangle()
                    .frame(height: 3)
                    .padding([.horizontal, .top])
                    .foregroundStyle(.gray.opacity(0.2))
                    
                
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text(mission.description)
                    
                    Rectangle()
                        .frame(height: 3)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                .padding(.horizontal)
            }
            
            CrewView(mission: mission, astronauts: astronauts)
        }
        .background(Image("background").blur(radius: 1))
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        let missions: [Mission] = Bundle.main.decode("missions.json")
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        
        return MissionView(mission: missions[5], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}
