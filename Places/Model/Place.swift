import Foundation
import SwiftUI

struct Place: Decodable, Sendable, Equatable {
    let locations: [Location]
}

// MARK: - Location
struct Location: Decodable, Sendable, Identifiable, Equatable {
    var id: UUID = UUID()
    let name: String?
    let lat, long: Double
    
    private enum CodingKeys: String, CodingKey {
        case name, lat, long
    }
    
    var displayName: String {
        name ?? "Unknown"
    }
    
    var displayLat: LocalizedStringKey {
        "Lat: \(lat, specifier: "%.4f")"
    }
    
    var displayLon: LocalizedStringKey {
        "Long: \(long, specifier: "%.4f")"
    }
}

extension Location {
    static let previewValue = Self(
        name: "Amsterdam",
        lat: 52.3547498,
        long: 4.8339215
    )
}

extension Place {
    static let mock = Self(
        locations: [
            .init(
                name: "Amsterdam",
                lat: 52.3547498,
                long: 4.8339215
            ),
            .init(
                name: "Mumbai",
                lat: 19.0823998,
                long: 72.8111468
            ),
            .init(
                name: "Copenhagen",
                lat: 55.6713442,
                long: 12.523785
            ),
            .init(
                name: nil,
                lat: 40.4380638,
                long: -3.7495758
            )
        ]
    )
}
