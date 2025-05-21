import SwiftUI
import MapKit

struct ListingDetailView: View {
    let listing: RoomListing
    @Environment(\.dismiss) var dismiss

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5821, longitude: 25.5550),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    @State private var checkInDate = Date()
    @State private var checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var guests = 1
    @State private var guestName = ""
    @State private var guestEmail = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: "http://127.0.0.1:5000\(listing.image)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(height: 320)
                    case .success(let image):
                        image.resizable().scaledToFill().frame(height: 320).clipped()
                    case .failure:
                        Color.gray.frame(height: 320)
                    @unknown default:
                        EmptyView()
                    }
                }
                .ignoresSafeArea(edges: .top)

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                        .background {
                            Circle().fill(.white).frame(width: 32, height: 32)
                        }
                        .padding(32)
                }
                .padding()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Room \(listing.room_number) - \(listing.room_type)").font(.title).fontWeight(.semibold)
                Text(listing.hotel_location).font(.subheadline).foregroundStyle(.gray)
            }
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Text("Room Information").font(.headline)
                Text("Type: \(listing.room_type)")
                Text("Price: $\(Int(listing.price_per_night)) per night")
                Text("Status: \(listing.status.capitalized)")
                    .foregroundColor(listing.status == "available" ? .green : .red)
            }
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Text("Reservation Details").font(.headline).padding(12)

                DatePicker("Check In", selection: $checkInDate, displayedComponents: .date).padding(12)
                DatePicker("Check Out", selection: $checkOutDate, displayedComponents: .date).padding(12)

                Stepper("Guests: \(guests)", value: $guests, in: 1...6).padding(12)

                if UserDefaults.standard.string(forKey: "auth_token") == nil {
                    TextField("Your Name", text: $guestName)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    TextField("Your Email", text: $guestEmail)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .padding(32)

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Text("Where you'll be").font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Map(coordinateRegion: $region)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
            .padding(32)
        }
        .ignoresSafeArea()
        .padding(.bottom, 64)
        .overlay(alignment: .bottom) {
            VStack {
                Divider().padding(.bottom)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$\(Int(listing.price_per_night))").font(.subheadline).fontWeight(.semibold)
                        Text("Total before taxes").font(.footnote)
                    }
                    .padding(.leading)

                    Spacer()

                    Button {
                        reserveRoom()
                    } label: {
                        Text("Reserve")
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 140, height: 40)
                            .background(.pink)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.horizontal, 42)
            }
            .background(.white)
        }
        .alert("Reservation", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    func reserveRoom() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let booking = BookingRequest(
            room_id: listing.id,
            guests: guests,
            check_in_date: formatter.string(from: checkInDate),
            check_out_date: formatter.string(from: checkOutDate)
        )

        if let token = UserDefaults.standard.string(forKey: "auth_token") {
            BookingService.bookRoomAsUser(token: token, request: booking) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        alertMessage = "Booking placed successfully!"
                    case .failure(let err):
                        alertMessage = "Failed to book: \(err.localizedDescription)"
                    }
                    showAlert = true
                }
            }
        } else {
            let guestBooking = GuestBookingRequest(
                room_id: booking.room_id,
                guests: booking.guests,
                check_in_date: booking.check_in_date,
                check_out_date: booking.check_out_date,
                guest_name: guestName,
                guest_email: guestEmail
            )

            BookingService.bookRoomAsGuest(request: guestBooking) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        alertMessage = "Guest booking placed successfully!"
                    case .failure(let err):
                        alertMessage = "Failed to book: \(err.localizedDescription)"
                    }
                    showAlert = true
                }
            }
        }
    }
}
