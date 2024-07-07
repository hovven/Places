import SwiftUI

struct ContentView: View {
    
    // Dependencies
    @StateObject var viewModel = PlacesModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            if viewModel.noPlaces {
                noContentView
            } else {
                List {
                    ForEach(viewModel.places.locations) { location in
                        PlaceRow(location: location)
                            .onTapGesture {
                                Task {
                                    await viewModel.didPressLocation(location)
                                }
                            }
                            .accessibilityElement()
                            .accessibilityLabel(location.displayName)
                            .accessibilityHint(LocalizedText.AccessibilityHint.tapToSeeLocation(location.displayName).text)
                    }
                }
                .navigationTitle(LocalizedText.navigationBarTitle.text)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(LocalizedText.addCustomLocationTitle.text) { viewModel.shouldShowAddCustomLocation = true }
                            .accessibilityLabel(LocalizedText.addCustomLocationTitle.text)
                            .accessibilityHint(LocalizedText.AccessibilityHint.tapToAddCustomLocation.text)
                    }
                }
            }
        }
        .overlay(loadingOverlay)
        .alert(
            viewModel.alertItem.title.description,
            isPresented: $viewModel.shouldOpenAppStore
        ) {
            Button(LocalizedText.cancelButtonText.text) { }
            Button(LocalizedText.confirmButtonText.text) {
                Task { await viewModel.openAppStore() }
            }
        } message: {
            Text(viewModel.alertItem.message)
        }
        .alert(
            viewModel.alertItem.title.description,
            isPresented: $viewModel.shouldShowInputError
        ) {
            Button(LocalizedText.confirmButtonText.text) { }
        } message: {
            Text(viewModel.alertItem.message)
        }
        .alert(
            viewModel.alertItem.title.description,
            isPresented: $viewModel.shouldOpenAppStore
        ) {
            Button(LocalizedText.cancelButtonText.text) { }
            Button(LocalizedText.confirmButtonText.text) {
                Task { await viewModel.openAppStore() }
            }
        } message: {
            Text(viewModel.alertItem.message)
        }
        .alert(
            LocalizedText.addCustomLocationTitle.text,
            isPresented: $viewModel.shouldShowAddCustomLocation
        ) {
            addCustomLocationAlertView
        } message: {
            Text(LocalizedText.enterLocationPromptText.text)
        }
        .task { await viewModel.fetchLocations() }
        .background(colorScheme == .dark ? .black : .white)
    }
    
    @ViewBuilder
    private var noContentView: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView(
                LocalizedText.placeHolderText.text,
                systemImage: "location.slash"
            )
            .accessibilityElement()
            .accessibilityLabel(LocalizedText.placeHolderText.text)
            .accessibilityHint(LocalizedText.AccessibilityHint.noContent.text)
        } else {
            Text(LocalizedText.placeHolderText.text)
                .accessibilityElement()
                .accessibilityLabel(LocalizedText.placeHolderText.text)
                .accessibilityHint(LocalizedText.AccessibilityHint.noContent.text)
        }
    }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.loadingState == .isLoading {
            ProgressView()
                .frame(width: 300, height: 300)
                .background(Color.white)
                .accessibilityLabel(LocalizedText.AccessibilityHint.loading.text)
                .accessibilityHint(LocalizedText.AccessibilityHint.loadingHint.text)
        } else {
            EmptyView()
                .accessibilityHint(LocalizedText.AccessibilityHint.loadingHint.text)
        }
    }
    
    @ViewBuilder
    @MainActor
    private var addCustomLocationAlertView: some View {
        TextField(
            LocalizedText.latitudeText.text,
            text: $viewModel.customLocationLat
        )
        .keyboardType(.numbersAndPunctuation)
        .accessibilityLabel(LocalizedText.latitudeText.text)
        .accessibilityHint(LocalizedText.AccessibilityHint.enterCustomLocationLat.text)
        
        TextField(
            LocalizedText.longitudeText.text,
            text: $viewModel.customLocationLong
        )
        .keyboardType(.numbersAndPunctuation)
        .accessibilityLabel(LocalizedText.latitudeText.text)
        .accessibilityHint(LocalizedText.AccessibilityHint.enterCustomLocationLong.text)
        
        Button(LocalizedText.submitButtonText.text) {
            Task {
                await viewModel.didUserEnterCustomLocation()
            }
        }
        .fontWeight(.bold)
        .accessibilityLabel(LocalizedText.submitButtonText.text)
        .accessibilityHint(LocalizedText.submitButtonText.text)
        
        Button(LocalizedText.cancelButtonText.text) { }
    }
}

#Preview("Light Mode") {
    ContentView()
        .environment(\.colorScheme, .light)
        .environmentObject(PlacesModel(apiClient: .testValue))
}

#Preview("Dark Mode") {
    ContentView()
        .environment(\.colorScheme, .dark)
        .environmentObject(PlacesModel(apiClient: .testValue))
}

#Preview("Empty Value") {
    ContentView()
        .environment(\.colorScheme, .light)
        .environmentObject(PlacesModel(apiClient: .emptyValue))
}
