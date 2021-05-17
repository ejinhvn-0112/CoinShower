//
//  Models.swift
//  Coin
//
//  Created by 김은중 on 2021/05/13.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let asset_id: String
    let url: String
}
