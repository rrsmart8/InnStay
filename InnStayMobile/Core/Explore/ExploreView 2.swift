import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var showDestinationSearchView = false
    @StateObject private var viewModel = RoomsViewModel()
    
    let onLogout: () -> Void  // <-- callback primit de la AuthRouterView

    var filteredListings: [RoomListing] {
        if searchText.isEmpty {
            return viewModel.listings
        } else {
            return viewModel.listings.filter {
                $0.hotel_location.localizedCaseInsensitiveContains(searchText) ||
                $0.hotel_name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Top bar
                HStack {
                    Button(action: {
                        UserDefaults.standard.removeObject(forKey: "auth_token")
                        onLogout() // <-- revino la login
                    }) {
                        Text("Logout")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.leading)
                            .padding(.top, 8)
                    }

                    Spacer()

                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.trailing)
                            .padding(.top, 8)
                    }
                }

                if showDestinationSearchView {
                    DestinationSearchView(show: $showDestinationSearchView, onSearch: { text in
                        self.searchText = text
                    })
                } else {
                    ScrollView {
                        SearchAndFilterBar()
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    showDestinationSearchView.toggle()
                                }
                            }

                        LazyVStack(spacing: 32) {
                            ForEach(filteredListings) { listing in
                                NavigationLink(value: listing) {
                                    ListingItemView(listing: listing)
                                        .frame(width: 350, height: 400)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        viewModel.fetchListings()
                    }
                    .navigationDestination(for: RoomListing.self) { listing in
                        ListingDetailView(listing: listing)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}
