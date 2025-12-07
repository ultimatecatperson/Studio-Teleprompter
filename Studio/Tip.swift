//
//  Tip.swift
//  Studio
//
//  Created by Xavier Finch on 12/7/25.
//

import Foundation
import TipKit

struct UseAICollaborationTip: Tip {
    var title: Text {
        Text("Collaborate with AI")
    }
    
    var message: Text? {
        Text("Use AI Collaboration to automatically write the next part of your script when you add double new lines.")
    }
    
    var image: Image? {
        Image(systemName: "sparkles")
    }
}
