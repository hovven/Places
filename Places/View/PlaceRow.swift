import SwiftUI

struct PlaceRow: View {
    let location: Location
    var body: some View {
        HStack {
            Image(systemName: "location")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
                .padding([.horizontal], 8)
            VStack(alignment: .leading, spacing: 5) {
                Text(location.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                HStack {
                    Text(location.displayLat)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(location.displayLon)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(10)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    PlaceRow(location: .previewValue)
}
