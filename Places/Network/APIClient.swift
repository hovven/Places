import Foundation

struct APIClient: Sendable {
    static let urlString = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    var fetchLocations: @Sendable () async throws -> Place
}

extension APIClient {
    static let liveValue = Self {
        
        guard let url = URL(string: urlString) else {
            throw PlaceError.Network.badURLError(urlString)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try data.decoded(as: Place.self)
    }
    
    static let testValue = Self {
        try await Task.sleep(nanoseconds: 1000)
        return .mock
    }
    
    static let emptyValue = Self { .init(locations: []) }
}
