import Foundation
import UIKit

struct Validator: Sendable {
    
    static let defaultWikipediaPlacesURL = "wikipedia://places"
    static let appStoreWikipediaURL = "https://apps.apple.com/us/app/wikipedia/id324715238"
    
    var canOpenURL: @Sendable (_ url: URL) async -> Bool
    var open: @Sendable (_ url: URL) async -> Bool
    var isLatitudeValid: @Sendable (Double) -> Bool
    var isLongitudeValid: @Sendable (Double) -> Bool
}

extension Validator {
    static let liveValue = Self { url in
        await UIApplication.shared.canOpenURL(url)
    } open: { @MainActor url in
        await UIApplication.shared.open(url)
    } isLatitudeValid: {
        (-90...90).contains($0)
    } isLongitudeValid: {
        (-180...180).contains($0)
    }

    static let testValue = Self { url in
        do { try await Task.sleep(nanoseconds: 1000) }
        catch { }
        return true
    } open: { url in
        do { try await Task.sleep(nanoseconds: 1000) }
        catch { }
        return true
    } 
    isLatitudeValid: { liveValue.isLatitudeValid($0) }
    isLongitudeValid: { liveValue.isLongitudeValid($0) }
}
