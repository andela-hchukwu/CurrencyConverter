//
//  CurrencyConversionPresenter.swift
//  Currency Converter
//
//  Created by Henry Chukwu on 8/6/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import Foundation

protocol CurrencyConverterView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setConversionData(_ convertedData: Conversion)
    func setErrorFromConversion(_ error: String)
}

class CurrencyConverterPresenter {

    weak fileprivate var currencyConverterView: CurrencyConverterView?

    func attachView(_ view: CurrencyConverterView) {
        self.currencyConverterView = view
    }

    func detachView() {
        self.currencyConverterView = nil
    }

    func getConversion(target currency: String) {
        self.currencyConverterView?.startLoading()
        CurrencyConverterService.instance.getLatestConversion(targetCurrency: currency) { [weak self] (conversion, error) in
            self?.currencyConverterView?.finishLoading()
            if error == nil {
                guard let convertedData = conversion else { return }
                self?.currencyConverterView?.setConversionData(convertedData)
            } else {
                self?.currencyConverterView?.setErrorFromConversion(error.debugDescription)
            }
        }
    }

}
