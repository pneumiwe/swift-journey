//
//  AstronautView.swift
//  Moonshot
//
//  Created by Tarannum on 28/08/26.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .shadow(color: .gray, radius: 20)
                
                Text(astronaut.id.capitalized)
                    .font(.largeTitle.bold())
                
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.black)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static var previews: some View {
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        
        return AstronautView(astronaut: astronauts["aldrin"]!)
            .preferredColorScheme(.dark)
    }
}
