import SwiftUI

struct Teleprompter: View {
    @State private var script: String = """
Paste your script here using the menu in the toolbar.
"""
    
    // Settings
    @State private var backgroundColor: Color = .black
    @State private var foregroundColor: Color = .white
    @State private var cursorColor: Color = .gray.opacity(0.5)
    @State private var fontSize: CGFloat = 50
    @State private var cursorSize: CGFloat = 75
    @State private var showSettings: Bool = false
    
    // Extras
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
                        // Auto scroll
                        ToolbarItem {
                            Button {
                                scrollToBottom.toggle()
                            } label: {
                                Image(systemName: "play.fill")
                            }
                        }
                        
                        // Scroll to top
                        ToolbarItem {
                            Button {
                                scrollToTop.toggle()
                            } label: {
                                Image(systemName: "arrow.up")
                            }
                        }
                        
                        // Hide or show keyboard
                        ToolbarItem {
                            Button {
                                isEditing.toggle()
                            } label: {
                                Image(systemName: isEditing ? "keyboard.chevron.compact.down" : "keyboard")
                                    .contentTransition(.symbolEffect(.replace))
                            }
                        }
                        
                        ToolbarItem {
                            // Script controls
                            Menu {
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
                                    if let text = UIPasteboard.general.string {
                                        script = text
                                    } else {
                                        script = ""
                                    }
                                } label: {
                                    Label("Paste to Script", systemImage: "document")
                                }
                                
                                Button {
                                    script = ""
                                } label: {
                                    Label("Clear Script", systemImage: "trash")
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
                        Capsule()
                            .frame(maxWidth: .infinity)
                            .frame(height: cursorSize)
                            .foregroundColor(cursorColor)
                        Spacer()
                    }
                }
                
                VStack {
                    // Settings
                    DisclosureGroup(isExpanded: $showSettings) {
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
                                .tint(foregroundColor)
                                Slider(
                                    value: $scrollDurationSeconds,
                                    in: 0...60,
                                    step: 1
                                ) {
                                    Text("Seconds")
                                }
                                .foregroundColor(foregroundColor)
                                .tint(foregroundColor)
                                Text("\(Int(scrollDurationMinutes)) minute\(scrollDurationMinutes == 1 ? "" : "s") and \(Int(scrollDurationSeconds)) second\(scrollDurationSeconds == 1 ? "" : "s")")
                                    .foregroundStyle(foregroundColor)
                            }
                            
                            VStack {
                                Slider(
                                    value: $fontSize,
                                    in: 12...140,
                                    step: 1
                                ) {
                                    Text("Text size")
                                }
                                .foregroundColor(foregroundColor)
                                .tint(foregroundColor)
                                Text("Text size: **\(Int(fontSize))** px")
                                    .foregroundStyle(foregroundColor)
                            }
                            
                            VStack {
                                Slider(
                                    value: $cursorSize,
                                    in: 0...200,
                                    step: 1
                                ) {
                                    Text("Cursor size")
                                }
                                .foregroundColor(foregroundColor)
                                .tint(foregroundColor)
                                Text("Cursor size: **\(cursorSize == 0 ? "OFF" : "\(Int(cursorSize)) px")**")
                                    .foregroundStyle(foregroundColor)
                            }
                            
                            ColorPicker("Cursor color", selection: $cursorColor)
                                .foregroundStyle(foregroundColor)
                            
                            ColorPicker("Text color", selection: $foregroundColor)
                                .foregroundStyle(foregroundColor)
                            
                            ColorPicker("Background color", selection: $backgroundColor)
                                .foregroundStyle(foregroundColor)
                        }
                    } label: {
                        Label(showSettings ? "Hide Settings" : "Show Settings", systemImage: "\(showSettings ? "chevron.up" : "chevron.down")")
                    }
                    .padding()
                    .background(backgroundColor.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .foregroundStyle(foregroundColor)
                    
                    Spacer()
                    
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
                        proxy.scrollTo("BottomAnchor", anchor: .top)
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
