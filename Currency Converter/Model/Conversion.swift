//
//  Conversion.swift
//  Currency Converter
//
//  Created by Henry Chukwu on 8/5/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import Foundation

struct Conversion: Decodable {
    public private(set) var success: String!
    public private(set) var timestamp: Int!
    public private(set) var base: String!
    public private(set) var date: String!
    public private(set) var rates: [String: Double]!
}
