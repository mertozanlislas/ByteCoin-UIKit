//
//  RateManager.swift
//  ByteCoin-UIKit
//
//  Created by Mert Ozan Lislas on 3/28/24.
//

import Foundation
protocol RateManagerDelegate {
    func didUpdateRate(firstCurrency:String,secondCurrency:String,price:String)
    func didFailWithError(error:Error)
}

struct RateManager{
    
    var delegate:RateManagerDelegate?
    let currencyArray = ["AUD","BRL","BTC","CAD","CNY","EUR","ETH","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","TRY","ZAR"]
    let baseUrl = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "PUT AN API KEY HERE"
    
    
    func fetchData(firstCurrency:String,secondCurrency:String){
        let urlString = "\(baseUrl)/\(firstCurrency)/\(secondCurrency)/apikey-\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let rateData = self.parseJSON(data: safeData){
                        let priceString = String(format: "%.2f", rateData.rate)
                        self.delegate?.didUpdateRate(firstCurrency: firstCurrency, secondCurrency: secondCurrency, price: priceString)
                    }
                    
                }
            }
            task.resume()
        }
    }
    func parseJSON (data:Data) -> RateData?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(RateData.self, from: data)
            return decodedData
        }catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


