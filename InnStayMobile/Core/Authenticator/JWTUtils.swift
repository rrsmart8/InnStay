//
//  JWTUtils.swift
//  InnStayMobile
//
//  Created by Rares Carbunaru on 5/21/25.
//

import Foundation

func decodeJWT(token: String) -> [String: Any]? {
    let parts = token.split(separator: ".")
    guard parts.count == 3 else { return nil }

    let payload = parts[1]
    var base64 = String(payload)
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

    // Padding
    while base64.count % 4 != 0 {
        base64.append("=")
    }

    guard let data = Data(base64Encoded: base64),
          let json = try? JSONSerialization.jsonObject(with: data),
          let dict = json as? [String: Any] else {
        return nil
    }

    return dict
}

