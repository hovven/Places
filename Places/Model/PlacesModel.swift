import Observation
import SwiftUI

@Observable
final class PlacesModel {
    // MARK: - Alert
    var alertItem: AlertItem = .init(title: .alert, message: "")
    var loadingState: LoadingState = .isLoading
    var shouldOpenAppStore = false
    var shouldShowAddCustomLocation = false
    var shouldShowInputError = false
    
    // MARK: -
    var noPlaces: Bool { places.locations.isEmpty }
    var places: Place = .init(locations: [])
    var customLocationLong = ""
    var customLocationLat = ""
    
    // MARK: - Dependencies
    private let apiClient: APIClient
    private let validator: Validator
    
    init(
        apiClient: APIClient = .liveValue,
        validator: Validator = .liveValue
    ) {
        self.apiClient = apiClient
        self.validator = validator
    }
    
    @MainActor
    func fetchLocations() async {
        loadingState = .isLoading
        do {
            places = try await apiClient.fetchLocations()
            loadingState = .isLoaded
        } catch {
            loadingState = .isLoaded
            if let error = error as? PlaceError.Network {
                alertItem = .init(title: .error, message: error.description)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func didPressLocation(_ location: Location) async {
        let urlString = Validator.defaultWikipediaPlacesURL + "?lat=\(location.lat)&lon=\(location.long)"
        
        guard let url = URL(string: urlString) else {
            alertItem = .init(title: .alert, message: PlaceError.URL.invalidDeepLinkURL(urlString).description)
            return
        }
        
        if await validator.canOpenURL(url) {
            let result = await validator.open(url)
            if !result {
                alertItem = .init(title: .error, message: PlaceError.URL.openURLFailed.description)
            }
        } else {
            shouldOpenAppStore = true
            alertItem = .init(title: .alert, message: "The Wikipedia app is not installed. Do you want to download it?")
        }
    }
    
    @MainActor
    func openAppStore() async {
        guard let appStoreURL = URL(string: Validator.appStoreWikipediaURL) else {
            alertItem = .init(title: .error, message: PlaceError.URL.invalidAppStoreURL(Validator.appStoreWikipediaURL).description)
            return
        }
        
        let result = await validator.open(appStoreURL)
        if !result {
            alertItem = .init(title: .error, message: PlaceError.URL.openURLFailed.description)
        }
    }
    
    @MainActor
    func didUserEnterCustomLocation() async {
        guard !customLocationLat.isEmpty && !customLocationLong.isEmpty else {
            alertItem = .init(title: .alert, message: PlaceError.Input.empty.description)
            shouldShowInputError = true
            return
        }
        
        guard
            let lat = Double(customLocationLat), /* validator.isLatitudeValid(lat), */
            let long = Double(customLocationLong)/*,  validator.isLongitudeValid(long) */
        else {
            alertItem = .init(title: .alert, message: PlaceError.Input.invalidRange(customLocationLat, customLocationLong).description)
            shouldShowInputError = true
            return
        }
        
        let location = Location(name: "custom", lat: lat, long: long)
        await didPressLocation(location)
    }
}
