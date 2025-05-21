//
//  AdminBooking.swift
//  InnStayMobile
//
//  Created by Rares Carbunaru on 5/21/25.
//

import Foundation

struct AdminBooking: Identifiable, Codable {
    let id: Int
    let user_email: String
    let hotel: String
    let perioada: String
    let pret: Double
    let status: String
}
