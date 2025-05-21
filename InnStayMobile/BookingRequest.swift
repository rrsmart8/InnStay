import Foundation

struct BookingRequest: Codable {
    let room_id: Int
    let guests: Int
    let check_in_date: String  // "YYYY-MM-DD"
    let check_out_date: String // "YYYY-MM-DD"
}
