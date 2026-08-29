//
//  ListLayout.swift
//  Moonshot
//
//  Created by Tarannum on 29/08/26.
//

import SwiftUI

struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    var body: some View {
        List {
            ForEach(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label: {
                    HStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                        
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.headline)
                            
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
            }
            .listRowBackground(Color.black.opacity(0.7))
            
        }
        .listStyle(.plain)
    }
}

struct ListLayout_Previews: PreviewProvider {
    static var previews: some View {
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        let missions: [Mission] = Bundle.main.decode("missions.json")
        
        return ListLayout(astronauts: astronauts, missions: missions)
            .preferredColorScheme(.dark)
        
    }
}
