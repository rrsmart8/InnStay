import Foundation

struct RoomListing: Codable, Identifiable, Hashable {
    let id: Int
    let hotel_id: Int
    let hotel_name: String
    let hotel_location: String
    let room_number: String
    let room_type: String
    let price_per_night: Double
    let status: String
    let image: String
}
