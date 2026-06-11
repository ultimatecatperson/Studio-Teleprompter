//
//  Created by Random Meow on 6/10/26.
//  You may use any code here, as long as you give credit. Thanks!
    

import SwiftUI
import FoundationModels

struct SettingsView: View {
    // Teleprompter
    @AppStorage("Default Font Size") var defaultFontSize: Double = 50.0
    @AppStorage("Default Cursor Size") var defaultCursorSize: Double = 100.0
    @AppStorage("Glass Cursor") var glassCursor: Bool = true
    
    // Script Writer
    @AppStorage("AI Feature") var aiFeature: Bool = true
    
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
                            in: 0...200,
                            step: 1
                        ) {
                            Text("Default Cursor size")
                        }
                        Text("Default Cursor Size: **\(Int(defaultCursorSize))** px")
                    }
                    
                    Toggle("Glass Cursor", isOn: $glassCursor)
                    
                    ZStack {
                        // Cursor
                        VStack {
                            Spacer()
                            if glassCursor {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.clear)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: defaultCursorSize)
                                    .glassEffect(.clear.tint(.gray.opacity(0.5)).interactive(), in: RoundedRectangle(cornerRadius: 30))
                            } else {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.gray.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: defaultCursorSize)
                            }
                            Spacer()
                        }
                        
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
                        .frame(height: 250)
                    }
                }
                
                Section("Script Writer") {
                    VStack {
                        Toggle("AI Feature", isOn: $aiFeature)
                        Text("AI feature uses Apple Intelligence, which is only available on iPhone 15 Pro and newer or iPad with M1 chip or newer.")
                            .font(.caption)
                        let model = SystemLanguageModel.default
                        switch model.availability {
                        case .available:
                            Text("You have Apple Intelligence.")
                                .foregroundStyle(.green)
                        case .unavailable(.deviceNotEligible):
                            Text("Apple Intelligence is not available on this device.")
                                .foregroundStyle(.red)
                        case .unavailable(.appleIntelligenceNotEnabled):
                            Text("You need to enable Apple Intelligence in Settings.")
                                .foregroundStyle(.yellow)
                        case .unavailable(.modelNotReady):
                            Text("The model isn't ready.")
                                .foregroundStyle(.red)
                        case .unavailable(_):
                            Text("Unknown error.")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                
                Section("Credits") {
                    Text("Made by Random Meow, 2026. You may use Studio for anything, including both personal and commercial projects.")
                        .font(.caption)
                    Link(destination: URL(string: "https://github.com/ultimatecatperson/Studio-Teleprompter")!) {
                        Label("Open source (GitHub)", systemImage: "arrow.up.forward")
                    }
                }
            }
            .navigationTitle("Settings")
            .task {
                
            }
        }
    }
}

#Preview {
    SettingsView()
}
