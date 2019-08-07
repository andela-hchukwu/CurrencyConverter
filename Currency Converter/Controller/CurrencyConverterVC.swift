//
//  CurrencyConverterVC.swift
//  Currency Converter
//
//  Created by Henry Chukwu on 8/5/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftCharts

class CurrencyConverterVC: UIViewController {

    @IBOutlet weak var topUIView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var roundedLabel: UILabel!
    @IBOutlet weak var baseCurrencyView: UIView!
    @IBOutlet weak var baseCurrencyTextField: UITextField!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyView: UIView!
    @IBOutlet weak var targetCurrencyTextField: UITextField!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var baseCurrencyButtomView: UIView!
    @IBOutlet weak var baseCurrencyDropdownButton: UIButton!
    @IBOutlet weak var baseCurrencyFlag: UIImageView!
    @IBOutlet weak var baseCurrencyButtomLbl: UILabel!
    @IBOutlet weak var targetCurrencyButtomView: UIView!
    @IBOutlet weak var targetCurrencyDrpdownButton: UIButton!
    @IBOutlet weak var targetCurrencyFlag: UIImageView!
    @IBOutlet weak var targetCurrencyButtomLbl: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var marketExchangeRateBtn: UIButton!
    @IBOutlet weak var marketExchangeHelpImageView: UIImageView!
    @IBOutlet weak var buttomUIView: UIView!
    @IBOutlet weak var pastThirtyDaysLbl: UILabel!
    @IBOutlet weak var thirtDaysGreenLbl: UILabel!
    @IBOutlet weak var thirtdaysBtn: UIButton!
    @IBOutlet weak var pastNinetyDaysLbl: UILabel!
    @IBOutlet weak var ninetyDaysGreenLbl: UILabel!
    @IBOutlet weak var ninetyDaysBtn: UIButton!
    @IBOutlet weak var graphView: UIView!
    
    fileprivate let presenter = CurrencyConverterPresenter()
    fileprivate var activity: UIActivityIndicatorView?

    fileprivate var targetCurrency = ""

    private var basePickerIsActive = false
    private var targetPickerIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        presenter.attachView(self)
        setupView()
    }

    private func setupView() {
        roundedLabel.rounded()
        thirtDaysGreenLbl.rounded()
        ninetyDaysGreenLbl.rounded()
        ninetyDaysGreenLbl.isHidden = true
        pastNinetyDaysLbl.alpha = 0.4
        thirtdaysBtn.isEnabled = false
        marketExchangeHelpImageView.rounded()
        baseCurrencyView.layer.cornerRadius = 5
        baseCurrencyButtomView.roundedCorner()
        targetCurrencyView.layer.cornerRadius = 5
        targetCurrencyButtomView.roundedCorner()
        convertButton.layer.cornerRadius = 5
        buttomUIView.layer.cornerRadius = 20

        if var baseSymbol = baseCurrencyLabel.text {
            baseSymbol.remove(at: baseSymbol.index(before: baseSymbol.endIndex))
            let emoji = emojiFlag(for: baseSymbol)
            baseCurrencyFlag.image = emoji?.image()
        }

        if var targetSymbol = targetCurrencyLabel.text {
            targetSymbol.remove(at: targetSymbol.index(before: targetSymbol.endIndex))
            let emoji = emojiFlag(for: targetSymbol)
            targetCurrencyFlag.image = emoji?.image()
        }


    }

    private func emojiFlag(for countryCode: String) -> String? {
        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }

        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))

    }

    func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
        return scalar.value >= 0x61 && scalar.value <= 0x7A
    }

    func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
        precondition(isLowercaseASCIIScalar(scalar))

        // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
        // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
        return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func convertBtnWasPressed(_ sender: Any) {
        guard let currency = targetCurrencyLabel.text else { return }
        targetCurrency = currency
        presenter.getConversion(target: currency)
    }

    @IBAction func thirtyDaysBtnWasPressed(_ sender: Any) {
        ninetyDaysGreenLbl.isHidden = true
        thirtDaysGreenLbl.isHidden = false
        pastNinetyDaysLbl.alpha = 0.4
        pastThirtyDaysLbl.alpha = 1.0
        thirtdaysBtn.isEnabled = false
        ninetyDaysBtn.isEnabled = true
    }

    @IBAction func ninetyDaysBtnWasPressed(_ sender: Any) {
        ninetyDaysGreenLbl.isHidden = false
        thirtDaysGreenLbl.isHidden = true
        pastNinetyDaysLbl.alpha = 1.0
        pastThirtyDaysLbl.alpha = 0.4
        thirtdaysBtn.isEnabled = true
        ninetyDaysBtn.isEnabled = false
    }

    @IBAction func baseCurrencyDropdownBtnWasPressed(_ sender: Any) {
        if !basePickerIsActive {
            basePickerIsActive = true
            let values = CURRENCY_SYMBOL
            ActionSheetStringPicker.show(withTitle: "Choose currency symbol", rows: values, initialSelection: 0, doneBlock: {
                picker, value, index in
                self.basePickerIsActive = false
                self.baseCurrencyLabel.text = index as? String
                self.baseCurrencyButtomLbl.text = index as? String
                if var symbol = index as? String {
                    symbol.remove(at: symbol.index(before: symbol.endIndex))
                    let emoji = self.emojiFlag(for: symbol)
                    self.baseCurrencyFlag.image = emoji?.image()
                }
                return
            }, cancel: { ActionMultipleStringCancelBlock in
                self.basePickerIsActive = false
                return

            }, origin: self.baseCurrencyDropdownButton)
        }
    }
    
    @IBAction func targetCurrencyDropdownBtnWasPressed(_ sender: Any) {
        if !targetPickerIsActive {
            targetPickerIsActive = true
            let values = CURRENCY_SYMBOL
            ActionSheetStringPicker.show(withTitle: "Choose currency symbol", rows: values, initialSelection: 0, doneBlock: {
                picker, value, index in
                self.targetPickerIsActive = false
                self.targetCurrencyLabel.text = index as? String
                self.targetCurrencyButtomLbl.text = index as? String
                if var symbol = index as? String {
                    symbol.remove(at: symbol.index(before: symbol.endIndex))
                    let emoji = self.emojiFlag(for: symbol)
                    self.targetCurrencyFlag.image = emoji?.image()
                }
                return
            }, cancel: { ActionMultipleStringCancelBlock in
                self.targetPickerIsActive = false
                return

            }, origin: self.targetCurrencyDrpdownButton)
        }
    }
}

extension CurrencyConverterVC: CurrencyConverterView {

    func startLoading() {
        // Show activity indicator
        activity = UIActivityIndicatorView()
        activity!.color = UIColor.black
        activity!.center = self.view.center
        activity!.bounds = self.view.bounds
        activity!.backgroundColor = UIColor.clear
        self.view.addSubview(activity!)
        activity!.startAnimating()
    }

    func finishLoading() {
        activity?.stopAnimating()
        activity?.isHidden = true
    }

    func setConversionData(_ convertedData: Conversion) {
        print(convertedData)
        if let rate = convertedData.rates[targetCurrency] {
            targetCurrencyTextField.text = "\(rate)"
        }
    }

    func setErrorFromConversion(_ error: String) {
        let alert = UIAlertController(title: "OOps!! Something went wrong.", message: error, preferredStyle: .alert)

        let errorMessage = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(errorMessage)
        self.present(alert, animated: true)
    }


}

