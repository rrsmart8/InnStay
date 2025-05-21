import Foundation

struct UserBooking: Identifiable, Codable {
    let id: Int
    let hotel: String
    let hotel_location: String
    let room_id: Int
    let room_type: String
    let room_image: String
    let price_per_night: Double
    let check_in_date: String
    let check_out_date: String
    let status: String
    let created_at: String

    var perioada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let checkIn = formatter.date(from: check_in_date),
           let checkOut = formatter.date(from: check_out_date) {
            let display = DateFormatter()
            display.dateFormat = "MMM dd"
            return "\(display.string(from: checkIn)) - \(display.string(from: checkOut))"
        }
        return "\(check_in_date) - \(check_out_date)"
    }
}
