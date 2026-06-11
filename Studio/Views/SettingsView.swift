//
//  Created by Random Meow on 6/10/26.
//  You may use any code here, as long as you give credit. Thanks!
    

import SwiftUI

struct SettingsView: View {
    @AppStorage("Default Font Size") var defaultFontSize: Double = 50.0
    @AppStorage("Default Cursor Size") var defaultCursorSize: Double = 100.0
    
    var body: some View {
        NavigationStack {
            List {
                Section("Teleprompter") {
                    VStack {
                        Slider(
                            value: $defaultFontSize,
                            in: 12...140,
                            step: 1
                        ) {
                            Text("Default Font size")
                        }
                        Text("Default Font Size: **\(Int(defaultFontSize))** px")
                    }
                    
                    VStack {
                        Slider(
                            value: $defaultCursorSize,
                            in: 0...400,
                            step: 1
                        ) {
                            Text("Default Cursor size")
                        }
                        Text("Default Cursor Size: **\(Int(defaultCursorSize))** px")
                    }
                    
                    Text("Restart the app to apply any changes.")
                        .font(.caption)
                    
                    ZStack {
                        ScrollView {
                            VStack {
                                ScrollViewReader { proxy in
                                    Text("""
                                 
                                 
                                 This is how it would look.
                                 Try scrolling.
                                 
                                 I would have maybe added a feature where Apple Intelligence generates a new sample text every time this shows up, but I couldn't think of what it would write about.
                                 
                                 Then I was thinking about pickles.
                                 I think pickles are good, but not everyone agrees. Probably, the smell is a little much sometimes.
                                 
                                 Anyway, I hope this looks good, and thanks for using my app!
                                 
                                 
                                 """)
                                    .font(.system(size: defaultFontSize))
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        .frame(height: 400)
                        
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(.clear)
                                .frame(maxWidth: .infinity)
                                .frame(height: defaultCursorSize)
                                .glassEffect(.clear.tint(.gray.opacity(0)).interactive(), in: RoundedRectangle(cornerRadius: 30))
                            Spacer()
                        }
                    }
                }
                
                Section("Credits") {
                    Text("Made by Random Meow, 2026. You may use Studio for anything, including both personal and commercial projects.")
                        .font(.caption)
                    Link(destination: URL(string: "https://github.com/ultimatecatperson/Studio-Teleprompter")!) {
                        Label("Open source", systemImage: "arrow.up.forward")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
