import SwiftUI

@main
struct PlacesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(PlacesModel())
        }
    }
}
