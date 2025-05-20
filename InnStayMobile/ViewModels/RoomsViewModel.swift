import Foundation

class RoomsViewModel: ObservableObject {
    @Published var listings: [RoomListing] = []

    func fetchListings() {
        guard let url = URL(string: "http://127.0.0.1:5000/api/rooms/get_rooms") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fetch error:", error)
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([RoomListing].self, from: data)
                DispatchQueue.main.async {
                    self.listings = decoded
                }
            } catch {
                print("Decoding error:", error)
                print("Raw JSON:", String(data: data, encoding: .utf8) ?? "nil")
            }
        }.resume()
    }
}
