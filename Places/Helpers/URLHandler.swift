import UIKit

struct URLHandler: Sendable {
    var open: @Sendable (_ url: URL) async -> Bool
}

extension URLHandler {
    static let liveValue = Self { @MainActor url in
        await UIApplication.shared.open(url)
    }

    static let testValue = Self { url in
        do { try await Task.sleep(nanoseconds: 1000) }
        catch { }
        return true
    }
}

