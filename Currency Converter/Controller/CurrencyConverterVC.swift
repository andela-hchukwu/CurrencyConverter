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
    @IBOutlet weak var baseCurrencybottomView: UIView!
    @IBOutlet weak var baseCurrencyFlag: UIImageView!
    @IBOutlet weak var baseCurrencybuttomLbl: UILabel!
    @IBOutlet weak var targetCurrencyFlag: UIImageView!
    @IBOutlet weak var targetCurrencyButtomLbl: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var marketExchangeRateBtn: UIButton!
    @IBOutlet weak var marketExchangeHelpImageView: UIImageView!
    @IBOutlet weak var ButtomUiView: UIView!

    fileprivate let presenter = CurrencyConverterPresenter()
    fileprivate var activity: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self)
    }

    @IBAction func convertBtnWasPressed(_ sender: Any) {
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
    }

    func setErrorFromConversion(_ error: String) {

    }


}

