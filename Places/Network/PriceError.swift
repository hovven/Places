enum PlaceError {
    
    enum Network: Error, CustomStringConvertible, Equatable {
        case decodingError
        case badURLError(String)
        
        var description: String {
            switch self {
            case let .badURLError(url):
                return "Invalid URL:\(url)"
            case .decodingError:
                return "Error decoding locations data"
            }
        }
    }
    
    enum URL: Error, CustomStringConvertible {
        case invalidDeepLinkURL(String)
        case openURLFailed
        case invalidAppStoreURL(String)
        
        var description: String {
            switch self {
            case let .invalidDeepLinkURL(url):
                return "Invalid deepLink URL:\(url)"
            case .openURLFailed:
                return "Failed to open the Wikipedia URL"
            case let .invalidAppStoreURL(url):
                return "Invalid appStore URL:\(url)"
            }
        }
    }
    
    enum Input: Error, CustomStringConvertible {
        typealias Latitude = String
        typealias Longitude = String
        
        case invalidRange(Latitude, Longitude)
        case empty
        
        var description: String {
            switch self {
            case let .invalidRange(lat, long):
                return "Latitude:\(lat), OR Longitude:\(long) out of range!"
            case .empty:
                return "Latitude or longitude is not entered!"
            }
        }
    }
}
