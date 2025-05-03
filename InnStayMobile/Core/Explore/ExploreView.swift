//
//  ExploreView.swift
//  InnStay
//
//  Created by Rares Carbunaru on 5/3/25.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                
                SearchAndFilterBar()
                
                LazyVStack(spacing: 32) {
                    ForEach(0 ... 5, id: \.self) { listing in
                        NavigationLink(value: listing) {
                            ListingItemView()
                                .frame(height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Int.self) { listing in
                ListingDetailView()
                    .navigationBarBackButtonHidden()
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ExploreView()
}
