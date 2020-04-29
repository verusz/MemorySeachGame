//
//  Image.swift
//  MemoryMatchingGame
//
//  Created by 朱继卿 on 2020-04-27.
//  Copyright © 2020 verus. All rights reserved.
//

import UIKit
class Image: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case src = "src"
    }
    
    var id = 0
    var src = ""
}
