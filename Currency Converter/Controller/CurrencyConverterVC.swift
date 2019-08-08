//
//  CurrencyConverterVC.swift
//  Currency Converter
//
//  Created by Henry Chukwu on 8/5/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Charts

class CurrencyConverterVC: UIViewController {

    @IBOutlet weak var topUIView: UIView!
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
    @IBOutlet weak var lineChartView: LineChartView!
    
    fileprivate let presenter = CurrencyConverterPresenter()
    fileprivate var activity: UIActivityIndicatorView?

    fileprivate var targetCurrency = ""
    fileprivate var baseAmount: Double?

//    fileprivate let markerView = MarkerView()

    private var basePickerIsActive = false
    private var targetPickerIsActive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        presenter.attachView(self)
        setupView()
        setupLineChart()

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

    private func setupLineChart() {

        var randomNumber = 3

        let values = (0...20).map { i -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(20)))
            randomNumber = Int(val)
            return ChartDataEntry(x: Double(i), y: (val + 3))
        }

        let set1 = LineChartDataSet(entries: values, label: "Exchange rate for the last 30 days")
        let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: colorLocations) // Gradient Object
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

        set1.fillAlpha = 1
        set1.drawFilledEnabled = true // Draw the Gradient
        set1.drawIconsEnabled = true
        let data = LineChartData(dataSet: set1)

        self.lineChartView.data = data
        let set2 = LineChartDataSet(entries: [values[randomNumber]], label: "")
//        let secondData = LineChartData(dataSet: set2)
        lineChartView.lineData?.addDataSet(set2)
        lineChartView.chartDescription?.text = ""
        lineChartView.noDataText = "Loading Data"
        lineChartView.backgroundColor = UIColor.clear

        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.dragEnabled = true
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = true
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.legend.enabled = true
        lineChartView.pinchZoomEnabled = true
        lineChartView.highlightPerTapEnabled = true
        lineChartView.highlightPerDragEnabled = false
        lineChartView.highlightValue(nil, callDelegate: false)

        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.labelCount = 5
        lineChartView.leftAxis.forceLabelsEnabled = true
        lineChartView.delegate = self

    }

//    func chartValueSelected(chartView: ChartViewBase, dataSetIndex: Int, highlight: Highlight) {
//
//        let graphPoint = chartView.getMarkerPosition(highlight: highlight)
//
//        // Adding top marker
//        markerView.dateLabel.text = "8 Aug"
//        markerView.exchangeRateLabel.text = "1 EUR - 4.12347"
//        markerView.center = CGPoint(x: graphPoint.x, y: markerView.center.y)
//        markerView.isHidden = false
//
//    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func convertBtnWasPressed(_ sender: Any) {
        guard let currency = targetCurrencyLabel.text,
            baseCurrencyTextField.text != nil,
            baseCurrencyTextField.text != ""
                else {
                    setErrorFromConversion("Type in a number to get it's equivalent in your preferred currency.", title: "Textfield cannot be empty")
                    return
        }
        if let amount = baseCurrencyTextField.text {
            baseAmount = Double(amount)
        }
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

        // remove spinner if visible before adding again
        if activity?.tag == 27 {
            activity?.stopAnimating()
            activity?.isHidden = true
        }

        // Show activity indicator
        activity = UIActivityIndicatorView()
        activity?.color = UIColor.white
        activity?.center = self.lineChartView.center
        activity?.bounds = self.lineChartView.bounds
        activity?.backgroundColor = UIColor.clear
        activity?.tag = 27
        self.lineChartView.addSubview(activity!)
        activity!.startAnimating()

        setupLineChart()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            // remove spinner if visible before adding again
            if self.activity?.tag == 27 {
                self.activity?.stopAnimating()
                self.activity?.isHidden = true
            }
        }

    }

    @IBAction func ninetyDaysBtnWasPressed(_ sender: Any) {
        ninetyDaysGreenLbl.isHidden = false
        thirtDaysGreenLbl.isHidden = true
        pastNinetyDaysLbl.alpha = 1.0
        pastThirtyDaysLbl.alpha = 0.4
        thirtdaysBtn.isEnabled = true
        ninetyDaysBtn.isEnabled = false

        // remove spinner if visible before adding again
        if activity?.tag == 27 {
            activity?.stopAnimating()
            activity?.isHidden = true
        }

        // Show activity indicator
        activity = UIActivityIndicatorView()
        activity?.color = UIColor.white
        activity?.center = self.lineChartView.center
        activity?.bounds = self.lineChartView.bounds
        activity?.backgroundColor = UIColor.clear
        activity?.tag = 27
        self.lineChartView.addSubview(activity!)
        activity!.startAnimating()

        setupLineChart()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            // remove spinner if visible before adding again
            if self.activity?.tag == 27 {
                self.activity?.stopAnimating()
                self.activity?.isHidden = true
            }
        }
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
    @IBAction func exchangeRateBtnWasPressed(_ sender: Any) {
        setErrorFromConversion("You are currently on the free plan, please upgrade to enjoy this feature.", title: "Info")
    }
    
}

extension CurrencyConverterVC: ChartViewDelegate {

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
        if let conversion = convertedData.rates[targetCurrency], let amount = baseAmount {
            // multiply the exchage rate by the amount from the baseCurrency
            let rate = conversion * amount
            let roundedRate = Double(round(100 * rate) / 100)
            if roundedRate == 0 {
                targetCurrencyTextField.text = "0.00"
            } else {
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 2
                formatter.minimum = 1
                let value = formatter.string(from: NSNumber(value: roundedRate))
                targetCurrencyTextField.text = value
            }
        }
    }

    func setErrorFromConversion(_ error: String, title: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)

        let errorMessage = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(errorMessage)
        self.present(alert, animated: true)
    }


}

