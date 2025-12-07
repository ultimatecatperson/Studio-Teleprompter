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

If you want it to stop scrolling, you can simply manual scroll a little bit and it'll stop.
"""
    
    // Settings
    @State private var backgroundColor: Color = .black
    @State private var foregroundColor: Color = .white
    @State private var cursorColor: Color = .gray
    @State private var fontSize: CGFloat = 48
    @State private var hideQuickSettings: Bool = false
    
    @State private var justCopied: Bool = false
    @State private var scrollToTop: Bool = false
    
    // Auto scrolling settings
    @State private var scrollToBottom: Bool = false
    @State private var scrollDurationMinutes: Double = 0
    @State private var scrollDurationSeconds: Double = 30
    
    @FocusState private var isEditing
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            teleprompter
                        }
                        .padding(.vertical, 500)
                    }
                    .background(backgroundColor)
                    .foregroundStyle(foregroundColor)
                    .toolbar {
                        ToolbarItem {
                            Button {
                                scrollToBottom.toggle()
                            } label: {
                                Image(systemName: "play.fill")
                            }
                        }
                        
                        ToolbarItem {
                            Button {
                                scrollToTop.toggle()
                            } label: {
                                Image(systemName: "arrow.up")
                            }
                        }
                        
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
                                    Menu {
                                        Button {
                                            backgroundColor = .black
                                            if foregroundColor == .black {
                                                foregroundColor = .white
                                            }
                                        } label: {
                                            Label("Black", systemImage: backgroundColor == .black ? "checkmark" : "")
                                        }
                                        Button {
                                            backgroundColor = .white
                                            if foregroundColor == .white {
                                                foregroundColor = .black
                                            }
                                        } label: {
                                            Label("White", systemImage: backgroundColor == .white ? "checkmark" : "")
                                        }
                                        Button {
                                            backgroundColor = .gray
                                            if foregroundColor == .gray {
                                                foregroundColor = .white
                                            }
                                        } label: {
                                            Label("Gray", systemImage: backgroundColor == .gray ? "checkmark" : "")
                                        }
                                    } label: {
                                        Label("Background", systemImage: "rectangle")
                                    }
                                    
                                    Menu {
                                        Button {
                                            foregroundColor = .black
                                            if backgroundColor == .black {
                                                backgroundColor = .white
                                            }
                                        } label: {
                                            Label("Black", systemImage: foregroundColor == .black ? "checkmark" : "")
                                        }
                                        Button {
                                            foregroundColor = .white
                                            if backgroundColor == .white {
                                                backgroundColor = .black
                                            }
                                        } label: {
                                            Label("White", systemImage: foregroundColor == .white ? "checkmark" : "")
                                        }
                                        Button {
                                            foregroundColor = .gray
                                            if backgroundColor == .gray {
                                                backgroundColor = .black
                                            }
                                        } label: {
                                            Label("Gray", systemImage: foregroundColor == .gray ? "checkmark" : "")
                                        }
                                    } label: {
                                        Label("Text", systemImage: "text.alignleft")
                                    }
                                    
                                    Menu {
                                        Button {
                                            cursorColor = .white
                                        } label: {
                                            Label("White", systemImage: cursorColor == .white ? "checkmark" : "")
                                        }
                                        Button {
                                            cursorColor = .gray
                                        } label: {
                                            Label("Gray", systemImage: cursorColor == .gray ? "checkmark" : "")
                                        }
                                        Button {
                                            cursorColor = .black
                                        } label: {
                                            Label("Black", systemImage: cursorColor == .black ? "checkmark" : "")
                                        }
                                        Button {
                                            cursorColor = .red
                                        } label: {
                                            Label("Red", systemImage: cursorColor == .red ? "checkmark" : "")
                                        }
                                        Button {
                                            cursorColor = .green
                                        } label: {
                                            Label("Green", systemImage: cursorColor == .green ? "checkmark" : "")
                                        }
                                        Button {
                                            cursorColor = .blue
                                        } label: {
                                            Label("Blue", systemImage: cursorColor == .blue ? "checkmark" : "")
                                        }
                                        Button {
                                            cursorColor = .accent
                                        } label: {
                                            Label("Accent", systemImage: cursorColor == .accent ? "checkmark" : "")
                                        }
                                        Button {
                                            cursorColor = .clear
                                        } label: {
                                            Label("None", systemImage: cursorColor == .clear ? "checkmark" : "")
                                        }
                                    } label: {
                                        Label("Cursor", systemImage: "rectangle.fill")
                                    }
                                } label: {
                                    Label("Color", systemImage: "paintpalette")
                                }
                                
                                Button {
                                    UIPasteboard.general.string = script
                                    justCopied = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            justCopied = false
                                        }
                                    }
                                } label: {
                                    Label("Copy Script", systemImage: "doc.on.doc")
                                }
                                
                                Button {
                                    hideQuickSettings.toggle()
                                } label: {
                                    Label(hideQuickSettings ? "Show Quick Settings" : "Hide Quick Settings", systemImage: "eye\(hideQuickSettings ? "" : ".slash")")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                }
                
                // Cursor
                if !isEditing {
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity)
                            .frame(height: fontSize * 2)
                            .foregroundColor(cursorColor.opacity(0.5))
                        Spacer()
                    }
                }
                
                // Quick settings
                if !isEditing && !hideQuickSettings {
                    VStack {
                        VStack {
                            Slider(
                                value: $scrollDurationMinutes,
                                in: 0...60,
                                step: 1
                            ) {
                                Text("Minutes")
                            }
                            .foregroundColor(foregroundColor)
                            Slider(
                                value: $scrollDurationSeconds,
                                in: 0...60,
                                step: 1
                            ) {
                                Text("Seconds")
                            }
                            .foregroundColor(foregroundColor)
                            Text("\(Int(scrollDurationMinutes)) minute\(scrollDurationMinutes == 1 ? "" : "s") and \(Int(scrollDurationSeconds)) second\(scrollDurationSeconds == 1 ? "" : "s")")
                                .foregroundStyle(foregroundColor)
                        }
                        .padding()
                        .background(backgroundColor.opacity(0.8))
                        .frame(maxHeight: 100)
                        
                        VStack {
                            Slider(
                                value: $fontSize,
                                in: 12...140,
                                step: 1
                            ) {
                                Text("Font size")
                            }
                            .foregroundColor(foregroundColor)
                            Text("\(Int(fontSize)) px")
                                .foregroundStyle(foregroundColor)
                        }
                        .padding()
                        .background(backgroundColor.opacity(0.8))
                        .frame(maxHeight: 100)
                        
                        Spacer()
                    }
                }
                
                // Alerts at the bottom of the screen
                VStack {
                    Spacer()
                    if justCopied {
                        ZStack {
                            Label("Copied to clipboard", systemImage: "checkmark")
                                .contentTransition(.symbolEffect(.replace))
                                .foregroundStyle(foregroundColor)
                        }
                        .padding()
                        .background(backgroundColor.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                }
            }
            .task {
                scrollToBottom.toggle()
            }
        }
    }
    
    var teleprompter: some View {
        ZStack {
            ScrollViewReader { proxy in
                VStack(alignment: .leading, spacing: 16) {
                    Color.clear
                        .frame(height: 1)
                        .id("TopAnchor")
                    
                    TextField("Script", text: $script, axis: .vertical)
                        .font(.system(size: fontSize))
                        .lineLimit(15...Int.max)
                        .focused($isEditing)
                    
                    Color.clear
                        .frame(height: 1)
                        .id("BottomAnchor")
                }
                .onChange(of: scrollToBottom) { oldValue, newValue in
                    withAnimation(.linear(duration: (scrollDurationMinutes * 60) + scrollDurationSeconds)) {
                        proxy.scrollTo("BottomAnchor", anchor: .bottom)
                    }
                }
                .onChange(of: scrollToTop) { oldValue, newValue in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo("TopAnchor", anchor: .bottom)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    Teleprompter()
}
