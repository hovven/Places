import XCTest
@testable import Places

final class PlacesTests: XCTestCase {
    
    func testFetchLocationsSuccess() async {
        let model = PlacesModel(apiClient: .testValue, validator: .testValue)
        
        await model.fetchLocations()
        
        XCTAssertEqual(model.loadingState, .isLoaded)
        XCTAssertEqual(model.places, .mock)
        XCTAssertFalse(model.noPlaces)
    }
    
    func testFetchLocationsFailure() async {
        let apiClient = APIClient { throw PlaceError.Network.badURLError("bad_url") }
        let model = PlacesModel(apiClient: apiClient, validator: .testValue)
        
        await model.fetchLocations()
        
        XCTAssertEqual(model.loadingState, .isLoaded)
        XCTAssertTrue(model.noPlaces)
        XCTAssertEqual(model.alertItem.message, PlaceError.Network.badURLError("bad_url").description)
    }
    
    func testDidPressLocationWithValidURL() async {
        let model = PlacesModel(apiClient: .emptyValue, validator: .testValue)
        
        let location = Location(name: "Test", lat: 0, long: 0)
        await model.didPressLocation(location)
        
        XCTAssertFalse(model.shouldOpenAppStore)
        XCTAssertEqual(model.alertItem.message, "")
    }
    
    func testDidPressLocationWithInvalidURL() async {
        let validator = Validator { _ in false }
        open: { _ in true }
        isLatitudeValid: { _ in true }
        isLongitudeValid: { _ in true }
        
        let model = PlacesModel(apiClient: .emptyValue, validator: validator)
        
        let location = Location(name: "Test", lat: 0, long: 0)
        await model.didPressLocation(location)
        
        XCTAssertTrue(model.shouldOpenAppStore)
        XCTAssertEqual(
            model.alertItem.message,
            "The Wikipedia app is not installed. Do you want to download it?"
        )
    }
    
    func testDidPressLocationOpenURLFailed() async {
        let validator = Validator { _ in true }
        open: { _ in false }
        isLatitudeValid: { _ in true }
        isLongitudeValid: { _ in true }
        
        let model = PlacesModel(apiClient: .emptyValue, validator: validator)
        
        let location = Location(name: "Test", lat: 0, long: 0)
        await model.didPressLocation(location)
        
        XCTAssertFalse(model.shouldOpenAppStore)
        XCTAssertEqual(
            model.alertItem.message,
            "Failed to open the Wikipedia URL"
        )
    }
    
    func testOpenAppStoreSuccess() async {
        let model = PlacesModel(apiClient: .emptyValue, validator: .testValue)
        
        await model.openAppStore()
        
        XCTAssertEqual(model.alertItem.message, "")
    }
    
    func testOpenAppStoreFailure() async {
        let apiClient = APIClient.emptyValue
        let validator = Validator { _ in true }
        open: { _ in false }
        isLatitudeValid: { _ in true }
        isLongitudeValid: { _ in true }
        
        let model = PlacesModel(apiClient: apiClient, validator: validator)
        
        await model.openAppStore()
        
        XCTAssertEqual(model.alertItem.message, PlaceError.URL.openURLFailed.description)
    }
    
    func testDidUserEnterCustomLocationEmptyLatOrLong() async {
        let model = PlacesModel(apiClient: .emptyValue, validator: .testValue)
        
        await model.didUserEnterCustomLocation()
        
        XCTAssertTrue(model.shouldShowInputError)
        XCTAssertEqual(model.alertItem.message, "Latitude or longitude is not entered!")
    }
    
    func testDidUserEnterCustomLocationValid() async {
        let model = PlacesModel(apiClient: .emptyValue, validator: .testValue)
        
        model.customLocationLat = "0"
        model.customLocationLong = "0"
        
        await model.didUserEnterCustomLocation()
        
        XCTAssertFalse(model.shouldShowInputError)
        XCTAssertEqual(model.alertItem.message, "")
    }
    
    func testDidUserEnterCustomLocationInvalid() async {
        let apiClient = APIClient.emptyValue
        let validator = Validator { _ in true }
        open: { _ in true }
        isLatitudeValid: { _ in false }
        isLongitudeValid: { _ in false }
        
        let model = PlacesModel(apiClient: apiClient, validator: validator)
        
        model.customLocationLat = "invalid"
        model.customLocationLong = "invalid"
        
        await model.didUserEnterCustomLocation()
        
        XCTAssertTrue(model.shouldShowInputError)
        XCTAssertEqual(model.alertItem.message, PlaceError.Input.invalidRange("invalid", "invalid").description)
    }
    
    func testValidatorLongitudeInvalidRange() async {
        let validator = Validator.testValue
        XCTAssertFalse(validator.isLongitudeValid(181))
    }
    
    func testValidatorLongitudeValidRange() async {
        let validator = Validator.testValue
        XCTAssertTrue(validator.isLongitudeValid(100))
    }
    
    func testValidatorLatitudeValidRange() async {
        let validator = Validator.testValue
        XCTAssertTrue(validator.isLatitudeValid(89))
    }
    
    func testValidatorLatitudeInvalidRange() async {
        let validator = Validator.testValue
        XCTAssertFalse(validator.isLatitudeValid(100))
    }
    
    func testDecodeValidPlace() {
        let jsonData = """
            {
                "locations": [
                    {
                        "name": "Amsterdam",
                        "lat": 52.3547498,
                        "long": 4.8339215
                    },
                    {
                        "name": "Mumbai",
                        "lat": 19.0823998,
                        "long": 72.8111468
                    },
                    {
                        "name": "Copenhagen",
                        "lat": 55.6713442,
                        "long": 12.523785
                    },
                    {
                        "name": null,
                        "lat": 40.4380638,
                        "long": -3.7495758
                    }
                ]
            }
            """.data(using: .utf8)!
        do {
            let place = try jsonData.decoded(as: Place.self)
            XCTAssertEqual(place.locations.count, 4)
            XCTAssertEqual(place.locations[0].name, "Amsterdam")
            XCTAssertEqual(place.locations[1].name, "Mumbai")
            XCTAssertEqual(place.locations[2].name, "Copenhagen")
            XCTAssertNil(place.locations[3].name)
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
    
    func testDecodeInvalidPlace() {
        let jsonData = """
            {
                "locations": [
                    {
                        "name": "Amsterdam",
                        "lat": 52.3547498,
                        "long": 4.8339215
                    },
                    {
                        "name": "Mumbai",
                        "lat": 19.0823998,
                        "long": 72.8111468
                    },
                    {
                        "name": "Copenhagen",
                        "lat": 55.6713442,
                        "long": 12.523785
                    },
                    {
                        "name": null,
                        "lat": 40.4380638,
                        "long": -3.7495758
                    }
                ]
            """.data(using: .utf8)!
        
        do {
            _ = try jsonData.decoded(as: Place.self)
            XCTFail("Decoding should have failed for invalid JSON")
        } catch {
            XCTAssertEqual(error as? PlaceError.Network, .decodingError)
        }
    }
    
    func testDecodeEmptyJSON() {
        let jsonData = Data()
        do {
            _ = try jsonData.decoded(as: Place.self)
            XCTFail("Decoding should have failed for empty JSON")
        } catch {
            XCTAssertEqual(error as? PlaceError.Network, .decodingError)
        }
    }
}
