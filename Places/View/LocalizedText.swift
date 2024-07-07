import SwiftUI

enum LocalizedText {
    case addCustomLocationTitle
    case cancelButtonText
    case confirmButtonText
    case enterLocationPromptText
    case latitudeText
    case longitudeText
    case navigationBarTitle
    case placeHolderText
    case submitButtonText
    
    var text: String {
        switch self {
        case .addCustomLocationTitle:
            return "Add Location"
        case .cancelButtonText:
            return "Cancel"
        case .confirmButtonText:
            return "Ok"
        case .enterLocationPromptText:
            return "Please enter your custom location"
        case .latitudeText:
            return "Longitude"
        case .longitudeText:
            return "Latitude"
        case .navigationBarTitle:
            return "Places"
        case .placeHolderText:
            return "No location available!"
        case .submitButtonText:
            return "Submit"
        }
    }
    
    enum AccessibilityHint {
        case noContent
        case tapToSeeLocation(String)
        case tapToAddCustomLocation
        case loading
        case loadingHint
        case enterCustomLocationLat
        case enterCustomLocationLong
        case submitLocation
        
        var text: String {
            switch self {
            case .noContent:
                return "No places available."
            case let .tapToSeeLocation(name):
                return "Tap to view details about \(name)."
            case .tapToAddCustomLocation:
                return "Tap to add a custom location."
            case .loading:
                return "Loading"
            case .loadingHint:
                return "Please wait while the data is loading."
            case .enterCustomLocationLat:
                return "Enter latitude for custom location."
            case .enterCustomLocationLong:
                return "Enter longitude for custom location."
            case .submitLocation:
                return "Submit custom location."
            }
        }
    }
}
