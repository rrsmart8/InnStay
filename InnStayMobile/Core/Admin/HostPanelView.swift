import SwiftUI

import SwiftUI

struct HostPanelView: View {
    let onLogout: () -> Void
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = HostPanelViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Button(action: {
                        onLogout()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 24)

                    Spacer()
                }
                .padding()

                Text("Admin Panel")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                ForEach(viewModel.bookings) { booking in
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(booking.user_email)
                                .font(.headline)

                            Text("Hotel: \(booking.hotel)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)

                            Text("Period: \(booking.perioada)")
                                .font(.footnote)

                            Text("Price: $\(Int(booking.pret))")
                                .font(.footnote)

                            Text("Status: \(booking.status.capitalized)")
                                .font(.footnote)
                                .foregroundColor(
                                    booking.status == "confirmed" ? .green :
                                    booking.status == "pending" ? .orange : .red
                                )
                        }
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.fetchAdminBookings()
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private func updateStatus(for bookingID: Int, to newStatus: String) {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else {
            print("No token available")
            return
        }

        AdminService.updateBookingStatus(token: token, bookingID: bookingID, status: newStatus) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    viewModel.fetchAdminBookings()
                }
            case .failure(let error):
                print("Status update failed:", error.localizedDescription)
            }
        }
    }

}

   
