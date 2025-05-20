import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Custom close button (top right)
                HStack {
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
                    .padding(32)
                }

                Text("Your Bookings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                ForEach(viewModel.bookings, id: \.id) { booking in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            AsyncImage(url: URL(string: "http://127.0.0.1:5000\(booking.room_image)")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(10)
                                case .failure:
                                    Color.gray.frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                @unknown default:
                                    EmptyView()
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text(booking.hotel)
                                    .font(.headline)
                                Text("\(booking.room_type)")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                Text("\(booking.perioada)")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                Text("Status: \(booking.status.capitalized)")
                                    .font(.footnote)
                                    .foregroundColor(
                                        booking.status == "confirmed" ? .green :
                                        booking.status == "pending" ? .orange : .red
                                    )
                            }

                            Spacer()
                        }
                        Divider()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.fetchBookings()
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
