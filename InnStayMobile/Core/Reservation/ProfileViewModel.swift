import Foundation

class ProfileViewModel: ObservableObject {
    @Published var bookings: [UserBooking] = []

    func fetchBookings() {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else {
            print("No token found")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:5000/api/bookings/my") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Booking fetch error:", error)
                return
            }

            guard let data = data else {
                print("No data in response")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([UserBooking].self, from: data)
                DispatchQueue.main.async {
                    self.bookings = decoded
                }
            } catch {
                print("Decoding error:", error)
                print("Raw JSON:", String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
}
