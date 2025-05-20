import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = RoomsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                SearchAndFilterBar()

                LazyVStack(spacing: 32) {
                    ForEach(viewModel.listings) { listing in
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

#Preview {
    ExploreView()
}
