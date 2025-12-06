//
//  Teleprompter.swift
//  Studio
//
//  Created by Xavier Finch on 12/6/25.
//

import SwiftUI

struct Teleprompter: View {
    @State private var script: String = """
Enter your script here. Your script is deleted when you close this page, so remember to copy the script up above and paste it into an app like Notes.
    
You may use this teleprompter for speeches, presentations, meetings, videos, and much more!
        
It's also easy to use. You can just type your script into this text area and even copy it in the menu in the toolbar above. When you adjust the settings, like the scroll speed and colors, then tap the Start button, it will start to scroll so you never lose your pace!
"""
    @State private var backgroundColor: Color = .black
    @State private var foregroundColor: Color = .white
    
    @State private var justCopied: Bool = false
    
    @FocusState private var isEditing
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    teleprompter
                        .padding(.vertical, 500)
                }
                .background(backgroundColor)
                .foregroundStyle(foregroundColor)
                .toolbar {
                    ToolbarItem {
                        Button {
                            isEditing.toggle()
                        } label: {
                            Image(systemName: isEditing ? "keyboard.chevron.compact.down" : "keyboard")
                                .contentTransition(.symbolEffect(.replace))
                        }
                    }
                    
                    ToolbarItem {
                        Menu {
                            Menu {
                                Button {
                                    backgroundColor = .black
                                    foregroundColor = .white
                                } label: {
                                    Text("White on Black")
                                }
                                Button {
                                    backgroundColor = .white
                                    foregroundColor = .black
                                } label: {
                                    Text("Black on White")
                                }
                                Button {
                                    backgroundColor = .gray
                                    foregroundColor = .white
                                } label: {
                                    Text("White on Gray")
                                }
                                Button {
                                    backgroundColor = .gray
                                    foregroundColor = .black
                                } label: {
                                    Text("Black on Gray")
                                }
                            } label: {
                                Label("Color", systemImage: "paintpalette")
                            }
                            
                            Button {
                                UIPasteboard.general.string = script
                                justCopied = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    justCopied = false
                                }
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
                
                // Alerts at the bottom of the screen
                VStack {
                    Spacer()
                    ZStack {
                        if justCopied {
                            Label("Copied to clipboard", systemImage: "checkmark")
                                .contentTransition(.symbolEffect(.replace))
                                .foregroundStyle(foregroundColor)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    var teleprompter: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Script", text: $script, axis: .vertical)
                    .font(.largeTitle)
                    .lineLimit(15...Int.max)
                    .focused($isEditing)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    Teleprompter()
}
