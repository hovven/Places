import SwiftUI

@main
struct PlacesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PlacesModel())
        }
    }
}
