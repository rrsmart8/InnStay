import SwiftUI

struct ExploreView: View {
    
    @State private var searchText = ""
    @State private var showDestinationSearchView = false
    @StateObject private var viewModel = RoomsViewModel()

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
                // Top bar: Profile button + SearchBar
                HStack {
                    Spacer()
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.top, 8)
                            .padding(.trailing)
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

#Preview {
    ExploreView()
}
