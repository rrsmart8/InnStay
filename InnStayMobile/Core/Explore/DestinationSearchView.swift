//
//  DestinationSearchView.swift
//  InnStayMobile
//
//  Created by Rares Carbunaru on 5/20/25.
//

import SwiftUI

struct DestinationSearchView: View {
    
    @Binding var show: Bool
    @State private var destination = ""
    
    var onSearch: (String) -> Void
    
    var body: some View {
        
        VStack {
            HStack {
                Button {
                    withAnimation(.snappy) {
                        show.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                }
                Spacer()
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Where to?")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.small)
                    TextField("Search destinations", text: $destination)
                        .font(.subheadline)
                }
                .frame(height: 44)
                .padding(.horizontal)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .foregroundStyle(Color(.systemGray4))
                }
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(radius: 10)
            
            Spacer()
            
            Button {
                // Trigger filtering or close view
                withAnimation(.snappy) {
                    show.toggle()
                }
                
                onSearch(destination)
            } label: {
                Text("Start Searching")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(.pink)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        
    }
}
//
//#Preview {
//    DestinationSearchView(show: .constant(false))
//}
