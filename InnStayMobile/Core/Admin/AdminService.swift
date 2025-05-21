import Foundation

class AdminService {
    static func updateBookingStatus(token: String, bookingID: Int, status: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/bookings/\(bookingID)/status") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: String] = ["status": status]

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 500)))
                return
            }

            if httpResponse.statusCode == 200 {
                completion(.success("Status updated successfully"))
            } else {
                let message = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: message, code: httpResponse.statusCode)))
            }
        }.resume()
    }
}
