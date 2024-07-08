enum URLFactory {
    static let defaultWikipediaPlacesURL = "wikipedia://places"
    static let appStoreWikipediaURL = "https://apps.apple.com/us/app/wikipedia/id324715238"
    
    static func makeLocationURL(with location: Location) -> String {
        defaultWikipediaPlacesURL + "?lat=\(location.lat)&lon=\(location.long)"
    }
}
