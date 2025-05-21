//
//  HotelPanelViewModel.swift
//  InnStayMobile
//
//  Created by Rares Carbunaru on 5/21/25.
//

import Foundation

class HostPanelViewModel: ObservableObject {
    @Published var bookings: [AdminBooking] = []

    func fetchAdminBookings() {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else {
            print("No token found.")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:5000/api/bookings/admin/all") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed:", error)
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([AdminBooking].self, from: data)
                DispatchQueue.main.async {
                    self.bookings = decoded
                }
            } catch {
                print("Decoding error:", error)
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            }
        }.resume()
    }
}
