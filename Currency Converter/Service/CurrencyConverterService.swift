//
//  CurrencyConverterService.swift
//  Currency Converter
//
//  Created by Henry Chukwu on 8/5/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrencyConverterService {

    private init() {}
    static let instance = CurrencyConverterService()

    func getLatestConversion(targetCurrency: String, completion: @escaping (Conversion?, String?) -> ()) {
        Alamofire.request("\(BASE_API)latest?access_key=\(FIXER_ACCESS_KEY)&symbols=\(targetCurrency)&format=1", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.error == nil {
                guard let data = response.data else { return }
                if let json = try? JSON(data: data) {
                    let success = json["success"].boolValue
                    let timeStamp = json["timestamp"].int
                    let base = json["base"].stringValue
                    let date = json["date"].stringValue
                    let rates = json["rates"].dictionaryObject as? [String: Double]

                    if success {
                        let conversion = Conversion(success: success, timestamp: timeStamp, base: base, date: date, rates: rates)
                        completion(conversion, nil)
                    } else {
                        let errorMsg = json["error"]["info"].stringValue
                        completion(nil, errorMsg)
                    }

                } else {
                    debugPrint(response.result.error as Any)
                    completion(nil, response.result.error.debugDescription)
                }
                
            }
        }

    }
}
