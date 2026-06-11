import Foundation
import FoundationModels

/// Controls where model computation is allowed to occur.
public enum ComputePolicy {
    /// Only run the model on-device.
    case onDeviceOnly
    /// Prefer on-device, but allow Private Cloud Compute if needed.
    case preferOnDeviceAllowPCC
    /// Require Private Cloud Compute.
    case requirePCC
}

/// Temporary wrapper that allows us to express PCC-related configuration even if the
/// underlying SDK surface differs. Replace with direct configuration when available.
struct ConfigurableLanguageModelSession {
    enum ExecutionPolicy {
        case onDeviceOnly
        case preferOnDeviceButAllowPCC
        case requirePrivateCloudCompute
    }

    private let base: LanguageModelSession
    var allowPrivateCloudCompute: Bool = false
    var executionPolicy: ExecutionPolicy = .onDeviceOnly

    init(instructions: String) {
        self.base = LanguageModelSession(instructions: instructions)
    }

    func respond(to prompt: String) async throws -> String {
        // Map `allowPrivateCloudCompute` and `executionPolicy` to real API when available.
        let response = try await base.respond(to: prompt)
        return response.content
    }
}

/// Generates a response from the on-device Foundation Model using the provided instructions and prompt.
/// - Parameters:
///   - instructions: System-style guidance for the model's behavior.
///   - prompt: The user's prompt or message.
///   - policy: Controls whether to use on-device only, prefer on-device but allow PCC, or require PCC.
/// - Returns: The model's textual response.
@MainActor
func Generate(instructions: String, prompt: String, policy: ComputePolicy = .requirePCC) async throws -> String {
    // Initialize a session with system instructions.
    var session = ConfigurableLanguageModelSession(instructions: instructions)

    // Configure compute policy.
    switch policy {
    case .onDeviceOnly:
        session.allowPrivateCloudCompute = false
        session.executionPolicy = .onDeviceOnly
    case .preferOnDeviceAllowPCC:
        session.allowPrivateCloudCompute = true
        session.executionPolicy = .preferOnDeviceButAllowPCC
    case .requirePCC:
        session.allowPrivateCloudCompute = true
        session.executionPolicy = .requirePrivateCloudCompute
    }

    // Request a response for the given prompt.
    let response = try await session.respond(to: prompt)
    return response
}

