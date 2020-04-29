//
//  CardsWrapper.swift
//  MemoryMatchingGame
//
//  Created by 朱继卿 on 2020-04-27.
//  Copyright © 2020 verus. All rights reserved.
//

import UIKit

class CardsWrapper: Codable {
    enum CodingKeys: String, CodingKey {
        case products = "products"
    }
    var products: [Card]?
}
