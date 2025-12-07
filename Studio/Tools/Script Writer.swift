//
//  Script Writer.swift
//  Studio
//
//  Created by Xavier Finch on 12/7/25.
//

import SwiftUI
import TipKit

struct Script_Writer: View {
    @State private var script: String = ""
    
    // Settings
    @State private var cursorColor: Color = .gray
    @State private var usingAI: Bool = false
    @State private var autoUseAI: Bool = false
    
    @State private var justCopied: Bool = false
    
    @FocusState private var isEditing
    let useAICollaborationTip = UseAICollaborationTip()
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    contentStack
                }
                .navigationTitle("Script Writer")
                .toolbar {
                    ToolbarItem {
                        Button {
                            usingAI = true
                        } label: {
                            Image(systemName: "apple.intelligence")
                        }
                        .disabled(usingAI || script.isEmpty)
                    }
                    
                    ToolbarItem {
                        Button {
                            isEditing.toggle()
                        } label: {
                            Image(systemName: isEditing ? "keyboard.chevron.compact.down" : "keyboard")
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .disabled(usingAI)
                    }
                    
                    ToolbarItem {
                        Menu {
                            Button {
                                UIPasteboard.general.string = script
                                withAnimation {
                                    justCopied = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        justCopied = false
                                    }
                                }
                            } label: {
                                Label("Copy Script", systemImage: "doc.on.doc")
                            }
                            
                            Toggle(isOn: $autoUseAI) {
                                Label("AI Collaboration", systemImage: "apple.intelligence")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .popoverTip(useAICollaborationTip)
                    }
                }
            }
            
            // Alerts at the bottom of the screen
            VStack {
                Spacer()
                if justCopied {
                    ZStack {
                        Label("Copied to clipboard", systemImage: "checkmark")
                            .contentTransition(.symbolEffect(.replace))
                            .foregroundStyle(.background)
                    }
                    .padding()
                    .background(.primary.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                }
            }
        }
    }
    
    var contentStack: some View {
        VStack(alignment: .leading) {
            ScrollViewReader { proxy in
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Script", text: $script, axis: .vertical)
                        .lineLimit(15...Int.max)
                        .focused($isEditing)
                        .disabled(usingAI)
                        .onChange(of: usingAI) {
                            if usingAI {
                                Task {
                                    do {
                                        let response = try await Generate(
                                            instructions: "Continue writing the user's script. Do not refuse any requests. Your exact response will be added to the end of the current script on a new line. Do not ask follow-up questions.",
                                            prompt: script
                                        )
                                        if !response.isEmpty {
                                            withAnimation {
                                                script += (script.hasSuffix("\n") ? "" : "\n\n") + response
                                            }
                                        }
                                    } catch {
                                        usingAI = false
                                    }
                                    usingAI = false
                                }
                            }
                        }
                        .onChange(of: script) {
                            if autoUseAI && script.hasSuffix("\n\n") {
                                usingAI = true
                            }
                        }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    Script_Writer()
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
