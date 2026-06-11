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
                    ToolThumbnail(title: "Teleprompter", imageName: "text.rectangle")
                        .symbolEffect(.wiggle.up.byLayer, options: .speed(0.5))
                }
                NavigationLink(destination: Script_Writer()) {
                    ToolThumbnail(title: "Script Writer", imageName: "pencil.and.ellipsis.rectangle")
                        .symbolEffect(.breathe, options: .speed(0.5))
                }
                NavigationLink(destination: SettingsView()) {
                    ToolThumbnail(title: "Settings", imageName: "gear")
                        .symbolEffect(.rotate, options: .speed(0.5))
                }
                
                ToolThumbnail(title: "More coming soon!", imageName: "")
            }
        }
    }
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
        .frame(maxHeight: .infinity)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
        .padding(5)
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
