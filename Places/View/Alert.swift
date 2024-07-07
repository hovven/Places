enum LoadingState {
    case isLoading
    case isLoaded
}

struct AlertItem {
    enum AlertType: CustomStringConvertible {
        case alert
        case error
        
        var description: String {
            switch self {
            case .alert:
                return "Alert!"
            case .error:
                return "Error!"
            }
        }
    }
    
    let title: AlertType
    let message: String
}
