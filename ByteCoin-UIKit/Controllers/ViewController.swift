//
//  ViewController.swift
//  ByteCoin-UIKit
//
//  Created by Mert Ozan Lislas on 3/28/24.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    var rateManager = RateManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rateManager.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(2, inComponent: 0, animated: true)
        pickerView.selectRow(21, inComponent: 1, animated: true)
        rateManager.fetchData(firstCurrency: "BTC", secondCurrency: "USD")
    }

    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let fistCurrency = rateManager.currencyArray[ pickerView.selectedRow(inComponent: 0) ]
        let secondCurrency = rateManager.currencyArray[ pickerView.selectedRow(inComponent: 1) ]
        rateManager.fetchData(firstCurrency: fistCurrency, secondCurrency: secondCurrency)
    }
    
}


extension ViewController:RateManagerDelegate{
    func didUpdateRate(firstCurrency: String, secondCurrency: String, price: String) {
        DispatchQueue.main.sync {
            self.rateLabel.text = price
            self.currencyLabel.text = secondCurrency
        }
        
    }
    func didFailWithError(error: Error) {
        debugPrint(error)
    }
    
    
}


extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rateManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rateManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}

