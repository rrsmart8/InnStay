import SwiftUI
import MapKit

struct ListingDetailView: View {
    let listing: RoomListing
    @Environment(\.dismiss) var dismiss

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5821, longitude: 25.5550), // Zona Brasov
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                // Imagine din Flask
                AsyncImage(url: URL(string: "http://127.0.0.1:5000\(listing.image)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 320)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 320)
                            .clipped()
                    case .failure:
                        Color.gray
                            .frame(height: 320)
                    @unknown default:
                        EmptyView()
                    }
                }
                .ignoresSafeArea(edges: .top)

                // Custom back button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                        .background {
                            Circle()
                                .fill(.white)
                                .frame(width: 32, height: 32)
                        }
                        .padding(32)
                }
                .padding(32)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Room \(listing.room_number) - \(listing.room_type)")
                    .font(.title)
                    .fontWeight(.semibold)

                Text(listing.hotel_location)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Text("Room Information")
                    .font(.headline)

                Text("Type: \(listing.room_type)")
                Text("Price: $\(Int(listing.price_per_night)) per night")
                Text("Status: \(listing.status.capitalized)")
                    .foregroundColor(listing.status == "available" ? .green : .red)
            }
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Text("Where you'll be")
                    .font(.headline)
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
                Divider()
                    .padding(.bottom)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$\(Int(listing.price_per_night))")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("Total before taxes")
                            .font(.footnote)
// TODO: Add Date Ranges which are not hardcoded
//                        Text("Oct 15 - 20")
//                            .font(.footnote)
//                            .fontWeight(.semibold)
//                            .underline()
                    }
                    .padding(.leading)

                    Spacer()

                    Button {
                        // rezervare
                       
                    } label: {
                        Text("Reserve")
                            .foregroundStyle(.white)
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
    }
    
    
}
