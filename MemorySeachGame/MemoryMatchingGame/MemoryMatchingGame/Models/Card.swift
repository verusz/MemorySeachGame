//
//  Card.swift
//  MemoryMatchingGame
//
//  Created by 朱继卿 on 2020-04-27.
//  Copyright © 2020 verus. All rights reserved.
//

import UIKit

class Card: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case image = "image"
    }
    var id = 0;
    var title = ""
    var image: Image!
}
