import SwiftUI

struct HostPanelView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = HostPanelViewModel()
    let onLogout: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Top bar: Logout + Close
                HStack {
                    Button("Logout") {
                        onLogout()
                    }
                    .foregroundColor(.red)
                    .padding(.leading)

                    Spacer()

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 32, height: 32)
                            }
                    }
                    .padding(.trailing)
                }
                .padding(.top, 24)

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

                        if booking.status == "pending" {
                            HStack(spacing: 16) {
                                Button("Confirm") {
                                    updateStatus(bookingID: booking.id, status: "confirmed")
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .background(.green)
                                .clipShape(Capsule())

                                Button("Reject") {
                                    updateStatus(bookingID: booking.id, status: "cancelled")
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .background(.red)
                                .clipShape(Capsule())
                            }
                            .padding(.top, 8)
                        }

                        Divider()
                    }
                    .padding(.horizontal)
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

    func updateStatus(bookingID: Int, status: String) {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else { return }

        AdminService.updateBookingStatus(token: token, bookingID: bookingID, status: status) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let msg):
                    print(msg)
                    viewModel.fetchAdminBookings()
                case .failure(let error):
                    print("Status update failed:", error.localizedDescription)
                }
            }
        }
    }
}
