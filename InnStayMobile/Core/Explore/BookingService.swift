import Foundation

class BookingService {
    static func bookRoomAsGuest(request: GuestBookingRequest, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/bookings/guest") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            if httpResponse.statusCode == 201 {
                completion(.success("Guest booking successful"))
            } else {
                let msg = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: msg, code: httpResponse.statusCode)))
            }
        }.resume()
    }
    
    static func bookRoomAsUser(token: String, request: BookingRequest, completion: @escaping (Result<String, Error>) -> Void) {
           guard let url = URL(string: "http://127.0.0.1:5000/api/bookings/") else {
               completion(.failure(NSError(domain: "Invalid URL", code: 400)))
               return
           }

           var urlRequest = URLRequest(url: url)
           urlRequest.httpMethod = "POST"
           urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
           urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

           do {
               urlRequest.httpBody = try JSONEncoder().encode(request)
           } catch {
               completion(.failure(error))
               return
           }

           URLSession.shared.dataTask(with: urlRequest) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let response = response as? HTTPURLResponse else {
                   completion(.failure(NSError(domain: "Invalid response", code: 500)))
                   return
               }

               if response.statusCode == 201 {
                   completion(.success("Booking successful"))
               } else {
                   completion(.failure(NSError(domain: "Booking failed", code: response.statusCode)))
               }
           }.resume()
       }
    
}
