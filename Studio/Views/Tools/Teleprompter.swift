import SwiftUI
import Foundation
internal import Combine

struct Teleprompter: View {
    @State private var script: String = """
Paste your script here using the menu in the toolbar.
"""
    
    // Settings
    @AppStorage("Default Scroll Speed") var defaultScrollSpeed: Double = 50.0
    @AppStorage("Default Font Size") private var defaultFontSize: Double = 50.0
    @AppStorage("Default Cursor Size") private var defaultCursorSize: Double = 100.0
    @AppStorage("Glass Cursor") private var glassCursor: Bool = true
    @State private var backgroundColor: Color = .black
    @State private var foregroundColor: Color = .white
    @State private var cursorColor: Color = .gray.opacity(0.5)
    @State private var fontSize: CGFloat = 50
    @State private var cursorSize: CGFloat = 100
    @State private var showSettings: Bool = false
    
    // Extras
    @State private var justCopied: Bool = false
    @State private var scrollToTop: Bool = false
    
    // Auto scrolling settings
    @State private var scrollSpeed: Double = 50
    @State private var scrollOffset: CGFloat = 0
    @State private var isAutoScrolling: Bool = false
    @State private var timer: Timer? = nil

    
    @FocusState private var isEditing
    
    // Auto scrolling timer (made with Gemini)
    func toggleScrolling() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        } else {
            // Here, 0.1 is the update interval (10 times per second)
            // scrollSpeed / 1000 determines how many units to jump
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                // This is pseudo-code for the implementation strategy:
                // You would use a GeometryReader or ScrollView offset binding
                // to adjust the Y-offset of your content stack by (scrollSpeed * constant)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Cursor
                if !isEditing {
                    VStack {
                        Spacer()
                        if glassCursor {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(.clear)
                                .frame(maxWidth: .infinity)
                                .frame(height: cursorSize)
                                .glassEffect(.clear.tint(cursorColor).interactive(), in: RoundedRectangle(cornerRadius: 30))
                        } else {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(cursorColor)
                                .frame(maxWidth: .infinity)
                                .frame(height: cursorSize)
                        }
                        Spacer()
                    }
                }
                
                VStack {
                    teleprompter
                }
                .foregroundStyle(foregroundColor)
                .toolbar {
                    // Auto scroll
                    ToolbarItem {
                        Button {
                            isAutoScrolling.toggle()
                        } label: {
                            Image(systemName: isAutoScrolling ? "pause.fill" : "play.fill")
                        }

                    }
                    
                    // Scroll to top
                    ToolbarItem {
                        Button {
                            scrollOffset = 0
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
                
                VStack {
                    // Settings
                    DisclosureGroup(isExpanded: $showSettings) {
                        VStack {
                            VStack {
                                Slider(
                                    value: $scrollSpeed,
                                    in: 10...200,
                                    step: 1
                                ) {
                                    Text("Speed")
                                }
                                .foregroundColor(foregroundColor)
                                .tint(foregroundColor)
                                Text("Speed: **\(Int(scrollSpeed))**")
                                    .foregroundStyle(foregroundColor)
                            }
                            
                            VStack {
                                Slider(
                                    value: $fontSize,
                                    in: 12...140,
                                    step: 1
                                ) {
                                    Text("Font size")
                                }
                                .foregroundColor(foregroundColor)
                                .tint(foregroundColor)
                                Text("Font size: **\(Int(fontSize))** px")
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
            .background(backgroundColor)
            .task {
                scrollSpeed = defaultScrollSpeed
                fontSize = defaultFontSize
                cursorSize = defaultCursorSize
            }
        }
    }
    
    var teleprompter: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Spacer(minLength: 440)
                Text(script)
                    .font(.system(size: fontSize))
                    .padding(.horizontal, 10)
            }
            .offset(y: -scrollOffset)
        }
        .onReceive(Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()) { _ in
            if isAutoScrolling {
                scrollOffset += (scrollSpeed / 100.0) * 0.3
            }
        }
    }

}

#Preview {
    Teleprompter()
}
