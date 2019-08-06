//
//  Currency_ConverterTests.swift
//  Currency ConverterTests
//
//  Created by Henry Chukwu on 8/5/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import XCTest
@testable import Currency_Converter

class CurrencyServiceMock: CurrencyConverterService {
    fileprivate let conversion =  Conversion(success: true, timestamp: 1565093106, base: "EUR", date: "2019-08-06", rates: ["USD": 1.118593])
//    let instance = CurrencyConverterService.instance.
//    init(conversion: Conversion) {
//        self.conversion = conversion
//        super.init()
//    }

    override func getLatestConversion(targetCurrency: String, completion: @escaping (Conversion?, Error?) -> ()) {
        completion(conversion, nil)
    }

}

class CurrencyConversionViewMock : NSObject, CurrencyConverterView {

    var setCurrencyConverted = false
    var noCurrencyConverted = false

    func setConversionData(_ convertedData: Conversion) {
        setCurrencyConverted = true
    }

    func setErrorFromConversion(_ error: String) {
        noCurrencyConverted = true
    }

    func startLoading() {
    }

    func finishLoading() {
    }

}

class Currency_ConverterTests: XCTestCase {

    func testShouldGetConversion() {
        // given
        let conversionViewMock = CurrencyConversionViewMock()
        let presenterUnderTest = CurrencyConverterPresenter()
        presenterUnderTest.attachView(conversionViewMock)

        // when
        presenterUnderTest.getConversion(target: "USD")

        // verify
        XCTAssertTrue(conversionViewMock.setCurrencyConverted)

    }

}
