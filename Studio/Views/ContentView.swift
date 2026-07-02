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
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    var contentStack: some View {
        VStack {
            VStack(alignment: .leading) {
                Section("Teleprompters") {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        NavigationLink(destination: SteadyScrollTeleprompter()) {
                            ToolThumbnail(title: "Steady scroll", imageName: "arrow.up")
                        }
                        NavigationLink(destination: Text("Coming soon")) {
                            ToolThumbnail(title: "Voice detection", imageName: "microphone")
                        }
                        .disabled(true)
                        .contextMenu {
                            Text("Coming soon")
                        }
                        NavigationLink(destination: Text("Coming soon")) {
                            ToolThumbnail(title: "Lyrics", imageName: "music.microphone")
                        }
                        .disabled(true)
                        .contextMenu {
                            Text("Coming soon")
                        }
                    } // LazyVGrid
                } // Section
                .font(.title.bold())
                
                Section("Tools") {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        NavigationLink(destination: Script_Writer()) {
                            ToolThumbnail(title: "Script Writer", imageName: "text.alignleft")
                        }
                    } // LazyVGrid
                } // Section
                .font(.title.bold())
                
                Section("Settings") {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        NavigationLink(destination: SettingsView()) {
                            ToolThumbnail(title: "Settings", imageName: "gear")
                        }
                    } // LazyVGrid
                } // Section
                .font(.title.bold())
            } // VStack with leading alignment
            
            Spacer(minLength: 50)
            
            VStack(alignment: .center) {
                Text("More coming soon")
                    .multilineTextAlignment(.center)
                    .font(.body.bold())
                Text("Version 2.0.1 Beta")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                HStack {
                    Link(destination: URL(string: "https://github.com/ultimatecatperson/Studio-Teleprompter")!) {
                        Label("Open source", systemImage: "arrow.up.forward")
                    }
                    Link(destination: URL(string: "mailto:randommeowofficial@icloud.com?subject=I%20want%20to%20join%20the%20beta%20for%20Studio:%20Teleprompter")!) {
                        Label("Join the beta", systemImage: "testtube.2")
                    }
                }
                .font(.caption)
                .buttonStyle(.glass)
                .buttonSizing(.fitted)
                .buttonBorderShape(.capsule)
                
                Text("Made by Random Meow :)")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .padding(.top, 10)
                    .foregroundStyle(.secondary)
                HStack {
                    Link(destination: URL(string: "https://youtube.com/@RandomMeowMain")!) {
                        Label("YouTube", systemImage: "play.rectangle.fill")
                    }
                    Link(destination: URL(string: "https://github.com/ultimatecatperson")!) {
                        Label("GitHub", systemImage: "person.circle")
                    }
                }
                .font(.caption)
                .buttonStyle(.glass)
                .buttonSizing(.fitted)
                .buttonBorderShape(.capsule)
            } // VStack
        } // VStack
    } // body
}

struct ToolThumbnail: View {
    @State var title: String
    @State var imageName: String = ""
    
    var body: some View {
        ZStack {
            /*LinearGradient(
                colors: [
                    color.opacity(0.4),
                    color.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )*/
            
            HStack(alignment: .center) {
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
        .frame(maxHeight: .infinity)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
        .padding(5)
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
