import SwiftUI

struct PanelView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Admin Panel")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Aici vom lista bookingurile mai târziu
                Text("Bookings will appear here.")
                    .padding()

                Spacer()
            }
            .navigationTitle("Host Dashboard")
        }
    }
}
