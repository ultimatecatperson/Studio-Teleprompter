import SwiftUI
import TipKit
import FoundationModels

struct Script_Writer: View {
    @State private var script: String = ""
    @State private var aiPrompt: String = ""
    
    // Settings
    @State private var cursorColor: Color = .gray
    @State private var usingAI: Bool = false
    
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
                    // Main toolbar area
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // Toggle the keyboard
                        Button {
                            isEditing.toggle()
                        } label: {
                            Image(systemName: isEditing ? "keyboard.chevron.compact.down" : "keyboard")
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .disabled(usingAI)
                        
                        // Copy‑script menu
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
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                    
                    // Bottom‑bar controls
                    ToolbarItemGroup(placement: .bottomBar) {
                        TextField(script.isEmpty ? "Start your script with AI" : "Edit your script with AI", text: $aiPrompt)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        
                        Button {
                            Task {
                                do {
                                    usingAI = true
                                    let session = LanguageModelSession(
                                        model: SystemLanguageModel(),
                                        instructions:
                                            """
                                            Edit the script based on the pwrompt.
                                            There is only one speaker, and do not add any tags or describe actions or scenes or anything like that unless the script already has them or the prompt says so.
                                            DO NOT use Markdown, because formatting doesn't work.
                                            Only provide the revised script in your response.
                                            
                                            """
                                    )
                                    let response = try await session.respond {
                                        """
                                        Prompt: "\(aiPrompt)"
                                        Script: "\(script)"
                                        """
                                    }
                                    if !response.content.isEmpty {
                                        withAnimation {
                                            script = response.content
                                        }
                                    }
                                    usingAI = false
                                    aiPrompt = ""
                                } catch {
                                    usingAI = false
                                }
                            }
                        } label: {
                            if !usingAI {
                                Image(systemName: "arrow.up")
                            } else {
                                ProgressView()
                            }
                        }
                        .disabled(usingAI)
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
                        .contentTransition(.numericText())
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    Script_Writer()
}
