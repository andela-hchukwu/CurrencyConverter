//
//  CurrencyConverterVC.swift
//  Currency Converter
//
//  Created by Henry Chukwu on 8/5/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit

class CurrencyConverterVC: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var roundedLabel: UILabel!
    @IBOutlet weak var baseCurrencyView: UIView!
    @IBOutlet weak var baseCurrencyTextField: UITextField!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyView: UIView!
    @IBOutlet weak var targetCurrencyTextField: UITextField!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var baseCurrencyButtomView: UIView!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var baseCurrencyFlag: UIImageView!
    @IBOutlet weak var baseCurrencyButtomLbl: UILabel!
    @IBOutlet weak var targetCurrencyButtomView: UIView!
    @IBOutlet weak var targetCurrencyButton: UIButton!
    @IBOutlet weak var targetCurrencyFlag: UIImageView!
    @IBOutlet weak var targetCurrencyButtomLbl: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var marketExchangeRateBtn: UIButton!
    @IBOutlet weak var marketExchangeHelpImageView: UIImageView!
    @IBOutlet weak var buttomUIView: UIView!

    fileprivate let presenter = CurrencyConverterPresenter()
    fileprivate var activity: UIActivityIndicatorView?

    fileprivate var targetCurrency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        presenter.attachView(self)
        setupView()
    }

    private func setupView() {
        roundedLabel.layer.cornerRadius = roundedLabel.frame.width / 2
        roundedLabel.layer.masksToBounds = true
        roundedLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        roundedLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        roundedLabel.layer.shadowOpacity = 0.8
        baseCurrencyView.layer.cornerRadius = 5
        baseCurrencyButtomView.layer.cornerRadius = 3
        baseCurrencyButtomView.layer.borderWidth = 1
        baseCurrencyButtomView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        targetCurrencyView.layer.cornerRadius = 5
        targetCurrencyButtomView.layer.cornerRadius = 3
        targetCurrencyButtomView.layer.borderWidth = 1
        targetCurrencyButtomView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        convertButton.layer.cornerRadius = 5
        buttomUIView.layer.cornerRadius = 20

        if let baseCountryFlag = baseCurrencyButtomLbl.text {
            flag(baseCountry: baseCountryFlag)
        }

    }

    private func flag(baseCountry: String) {
//        let base: UInt32 = 127397
//        var baseString = ""
//        var targetString = ""
//        var baseCountryScalar = baseCountry.unicodeScalars.makeIterator()
//        var targetCountryScalar = targetCountry.unicodeScalars.makeIterator()
//
//        while let v1 = baseCountryScalar.next(), let v2 = targetCountryScalar.next() {
//            if let baseValue = Unicode.Scalar(base + v1.value), let targetValue = Unicode.Scalar(base + v2.value) {
//                baseString.unicodeScalars.append(baseValue)
//                targetString.unicodeScalars.append(targetValue)
//            }
//        }

        let base : UInt32 = 127397
        var s = ""
        for v in baseCountry.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }

        baseCurrencyFlag.image = UIImage(named: s)
//        targetCurrencyFlag.image = UIImage(named: String(targetString))
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func convertBtnWasPressed(_ sender: Any) {
        guard let currency = targetCurrencyLabel.text else { return }
        targetCurrency = currency
        presenter.getConversion(target: currency)
    }

    @IBAction func signUpBtnWasPressed(_ sender: Any) {
    }

    @IBAction func toggleBtnWasPressed(_ sender: Any) {
    }
    
}

extension CurrencyConverterVC: CurrencyConverterView {

    func startLoading() {
        // Show activity indicator
        activity = UIActivityIndicatorView()
        activity!.color = UIColor.black
        activity!.center = self.view.center
        activity!.bounds = self.view.bounds
        activity!.backgroundColor = UIColor.white
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

        let errorMessage = UIAlertAction(title: "Dismiss", style: .default)
        alert.addAction(errorMessage)
        present(alert, animated: true)
    }


}

