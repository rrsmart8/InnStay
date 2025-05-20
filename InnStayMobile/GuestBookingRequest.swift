struct GuestBookingRequest: Codable {
    let room_id: Int
    let guest_name: String
    let guest_email: String
    let guests: Int
    let check_in_date: String
    let check_out_date: String
}
