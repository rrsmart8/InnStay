//
//  ListingView.swift
//  InnStay
//
//  Created by Rares Carbunaru on 5/3/25.
//

import SwiftUI

struct ListingItemView: View {
    let listing: RoomListing

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: "http://127.0.0.1:5000\(listing.image)")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 320)
                case .success(let image):
                    image.resizable()
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

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(listing.hotel_location)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)

                    Text("Nov 3 - 10") // hardcoded example

                    HStack(spacing: 4) {
                        Text("$\(Int(listing.price_per_night))")
                            .fontWeight(.semibold)
                        Text("night")
                    }
                    .foregroundStyle(.black)
                }

                Spacer()

                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                    Text("4.86")
                }
                .foregroundStyle(.black)
            }
            .font(.footnote)
        }
    }
}

