//
//  ContentView.swift
//  Studio
//
//  Created by Random Meow on 12/5/25.
//

import SwiftUI
import TipKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                contentStack
            }
            .padding()
            .navigationTitle("Studio")
        }
    }
    
    var contentStack: some View {
        VStack(alignment: .leading) {
            Label("Tools", systemImage: "wrench.and.screwdriver.fill")
                .font(.title.bold())
            
            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                NavigationLink(destination: Teleprompter()) {
                    ToolThumbnail(title: "Teleprompter", imageName: "text.rectangle", color: .red)
                        .symbolEffect(.wiggle.up.byLayer, options: .speed(0.5))
                }
                NavigationLink(destination: Script_Writer()
                    .task {
                        try? Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }) {
                    ToolThumbnail(title: "Script Writer", imageName: "pencil.and.ellipsis.rectangle", color: .blue)
                        .symbolEffect(.breathe, options: .speed(0.5))
                }
                /*ToolThumbnail(title: "Settings", imageName: "gear", color: .accent)
                    .symbolEffect(.rotate, options: .speed(0.5))*/
                
                ToolThumbnail(title: "More coming soon!", imageName: "", color: .gray)
            }
        }
    }
}

struct ToolThumbnail: View {
    @State var title: String
    @State var imageName: String = ""
    @State var color: Color = .accent
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    color.opacity(0.4),
                    color.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .center) {
                Image(systemName: imageName)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 125)
        .cornerRadius(15)
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
