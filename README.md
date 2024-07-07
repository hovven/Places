# Places

Wikipedia iOS App Deep Linking Enhancement

Overview

This project enhances the Wikipedia iOS app to handle deep links that navigate directly to the ‘Places’ tab with specified coordinates.

    
#### Repositories

* Wikipedia iOS App: [forked-wikipedia-ios](https://github.com/hovven/wikipedia-ios)
* Places Test App: [Places](https://github.com/hovven/Places)

#### Features
* Deep Link Handling: Opens the ‘Places’ tab with given coordinates via deep links.
* Swift concurrency and accessibility
* Unit Tests: Includes tests for the URL validation helper.
* iOS Version Support: Supports the latest iOS version, with a [**Pull Request**](https://github.com/hovven/Places/pull/1) for iOS 16 compatibility.

#### Setup
Clone the Repositories:

    git clone https://github.com/hovven/wikipedia-ios.git
    git clone https://github.com/hovven/Places.git

Follow the setup process described in the original [Wikipedia iOS app](https://github.com/wikimedia/wikipedia-ios?tab=readme-ov-file#building-and-running) repository.

Note: Ensure the cloned repository includes the [Latest changes](https://github.com/hovven/wikipedia-ios/pull/1) from the forked repository.

#### Places App
* SwiftUI Interface: Displays a list of locations fetched from a remote JSON file
* Custom Location Entry: Allows users to enter custom coordinates
* Deep Link Demonstration: Opens the Wikipedia app with the specified location
* VoiceOver Support: Ensures all interactive elements are accessible
* Accessibility Labels: Adds descriptive labels to UI elements for better accessibility
