//
//  ViewController.swift
//  Currency
//
//  Created by Robert O'Connor on 18/10/2017.
//  Copyright © 2017 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK Model holders
    var currencyDict:Dictionary = [String:Currency]()
    var currencyArray = [Currency]()
    var curName : String! = ""
    var curFlag: String! = ""
    var curSymbol :String! = ""
    var baseCurrency:Currency? = nil
    //var baseCurrency:Currency = Currency(name:curName, rate:curRate, flag:curFlag, symbol:curSymbol)!
    var lastUpdatedDate:Date = Date()
    
    var convertValue:Double = 0
    
    let currencies = ["EUR","GBP","USD","JPY","AUD","CAD","PLN","DKK","BGN"]
    
    //MARK Outlets
    //@IBOutlet weak var convertedLabel: UILabel!
    
    @IBOutlet weak var baseSymbol: UILabel!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var baseFlag: UILabel!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    @IBOutlet weak var eurSymbolLabel: UILabel!
    @IBOutlet weak var eurValueLabel: UILabel!
    @IBOutlet weak var eurFlagLabel: UILabel!
    
    @IBOutlet weak var gbpSymbolLabel: UILabel!
    @IBOutlet weak var gbpValueLabel: UILabel!
    @IBOutlet weak var gbpFlagLabel: UILabel!
    
    @IBOutlet weak var usdSymbolLabel: UILabel!
    @IBOutlet weak var usdValueLabel: UILabel!
    @IBOutlet weak var usdFlagLabel: UILabel!
    
    @IBOutlet weak var jpySymbolLabel: UILabel!
    @IBOutlet weak var jpyValueLabel: UILabel!
    @IBOutlet weak var jpyFlagLabel: UILabel!
    
    @IBOutlet weak var audSymbolLabel: UILabel!
    @IBOutlet weak var audValueLabel: UILabel!
    @IBOutlet weak var audFlagLabel: UILabel!
    
    @IBOutlet weak var cadSymbolLabel: UILabel!
    @IBOutlet weak var cadValueLabel: UILabel!
    @IBOutlet weak var cadFlagLabel: UILabel!
    
    @IBOutlet weak var plnSymbolLabel: UILabel!
    @IBOutlet weak var plnValueLabel: UILabel!
    @IBOutlet weak var plnFlagLabel: UILabel!
    
    @IBOutlet weak var dkkSymbolLabel: UILabel!
    @IBOutlet weak var dkkValueLabel: UILabel!
    @IBOutlet weak var dkkFlagLabel: UILabel!
    
    @IBOutlet weak var bgnSymbolLabel: UILabel!
    @IBOutlet weak var bgnValueLabel: UILabel!
    @IBOutlet weak var bgnFlagLabel: UILabel!
    
    @IBOutlet weak var activityView: UIView!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseCurrency = Currency(name:"EUR", rate:1, flag:"🇪🇺", symbol: "€")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        // print("currencyDict has \(self.currencyDict.count) entries")
        
        // create currency dictionary
        self.createCurrencyDictionary()
        
        // get latest currency values
        getTable()
      //  getConversionTable()
      //  convertValue = 1
        
        // set up base currency screen items
        baseTextField.text = String(format: "%.02f", (baseCurrency?.rate)!)
        baseSymbol.text = baseCurrency?.symbol
        baseFlag.text = baseCurrency?.flag
        
        // set up last updated date
       // let dateformatter = DateFormatter()
       // dateformatter.dateFormat = "dd/MM/yyyy hh:mm a"
       // lastUpdatedDateLabel.text = dateformatter.string(from: lastUpdatedDate)
        
        // display currency info
        self.displayCurrencyInfo()
        
        
        // setup view mover
        baseTextField.delegate = self
        
        self.convert(self)
        
        // add done button to keyboard
        addDoneButton()
    }
    
    func addDoneButton(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let done : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.baseTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        convert()
        self.baseTextField.resignFirstResponder()
    }
    
    func getTable(){
        getConversionTable()
        convertValue = 1
        baseTextField.text = String(format: "%.02f", (baseCurrency?.rate)!)
        baseSymbol.text = baseCurrency?.symbol
        baseFlag.text = baseCurrency?.flag
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm a"
        lastUpdatedDateLabel.text = dateformatter.string(from: lastUpdatedDate)
        convert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCurrencyDictionary(){
        //let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
        //self.currencyDict[name] = c
        currencyDict["EUR"] = Currency(name:"EUR", rate:1, flag:"🇪🇺", symbol: "€")
        currencyDict["GBP"] = Currency(name:"GBP", rate:1, flag:"🇬🇧", symbol: "£")
        currencyDict["USD"] = Currency(name:"USD", rate:1, flag:"🇺🇸", symbol: "$")
        currencyDict["JPY"] = Currency(name:"JPY", rate:1, flag:"🇯🇵", symbol: "¥")
        currencyDict["AUD"] = Currency(name:"AUD", rate:1, flag:"🇦🇺", symbol: "$")
        currencyDict["CAD"] = Currency(name:"CAD", rate:1, flag:"🇨🇦", symbol: "$")
        currencyDict["PLN"] = Currency(name:"PLN", rate:1, flag:"🇵🇱", symbol: "zł")
        currencyDict["DKK"] = Currency(name:"DKK", rate:1, flag:"🇩🇰", symbol: "kr")
        currencyDict["BGN"] = Currency(name:"BGN", rate:1, flag:"🇧🇬", symbol: "лв")
    }
    
    func displayCurrencyInfo() {
        if let c = currencyDict["EUR"]{
            eurSymbolLabel.text = c.symbol
            eurValueLabel.text = String(format: "%.02f", c.rate)
            eurFlagLabel.text = c.flag
        }
        if let c = currencyDict["GBP"]{
            gbpSymbolLabel.text = c.symbol
            gbpValueLabel.text = String(format: "%.02f", c.rate)
            gbpFlagLabel.text = c.flag
        }
        if let c = currencyDict["USD"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
       if let c = currencyDict["JPY"]{
            jpySymbolLabel.text = c.symbol
            jpyValueLabel.text = String(format: "%.02f", c.rate)
            jpyFlagLabel.text = c.flag
        }
        if let c = currencyDict["AUD"]{
            audSymbolLabel.text = c.symbol
            audValueLabel.text = String(format: "%.02f", c.rate)
            audFlagLabel.text = c.flag
        }
        if let c = currencyDict["CAD"]{
            cadSymbolLabel.text = c.symbol
            cadValueLabel.text = String(format: "%.02f", c.rate)
            cadFlagLabel.text = c.flag
        }
        if let c = currencyDict["PLN"]{
            plnSymbolLabel.text = c.symbol
            plnValueLabel.text = String(format: "%.02f", c.rate)
            plnFlagLabel.text = c.flag
        }
        if let c = currencyDict["DKK"]{
            dkkSymbolLabel.text = c.symbol
            dkkValueLabel.text = String(format: "%.02f", c.rate)
            dkkFlagLabel.text = c.flag
        }
        if let c = currencyDict["BGN"]{
            bgnSymbolLabel.text = c.symbol
            bgnValueLabel.text = String(format: "%.02f", c.rate)
            bgnFlagLabel.text = c.flag
        }
    }
    
    
    func getConversionTable() {
        //var result = "<NOTHING>"
        
        let urlStr:String = "https://api.fixer.io/latest?base=\(baseCurrency!.name)"
        
        var request = URLRequest(url: URL(string: urlStr)!)
        let session = URLSession(configuration: .default)
        request.httpMethod = "GET"
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.center = activityView.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityView.addSubview(indicator)
        indicator.startAnimating()
        
        
        let task = session.dataTask(with: request) {data, response, error in
            
            if error == nil{
                //print(response!)
                
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    //print(jsonDict)
                    
                    if let ratesData = jsonDict["rates"] as? NSDictionary {
                        //print(ratesData)
                        for rate in ratesData{
                            //print("#####")
                            let name = String(describing: rate.key)
                            let rate = (rate.value as? NSNumber)?.doubleValue
                            //var symbol:String
                            //var flag:String
                            
                            switch(name){
                            case "USD":
                                //symbol = "$"
                                //flag = "🇺🇸"
                                let c:Currency  = self.currencyDict["USD"]!
                                c.rate = rate!
                                self.currencyDict["USD"] = c
                            case "GBP":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["GBP"]!
                                c.rate = rate!
                                self.currencyDict["GBP"] = c
                            case "JPY":
                                let c:Currency = self.currencyDict["JPY"]!
                                c.rate = rate!
                                self.currencyDict["JPY"] = c
                            case "AUD":
                                let c:Currency = self.currencyDict["AUD"]!
                                c.rate = rate!
                                self.currencyDict["AUD"] = c
                            case "CAD":
                                let c:Currency = self.currencyDict["CAD"]!
                                c.rate = rate!
                                self.currencyDict["CAD"] = c
                            case "PLN":
                                let c:Currency = self.currencyDict["PLN"]!
                                c.rate = rate!
                                self.currencyDict["PLN"] = c
                            case "DKK":
                                let c:Currency = self.currencyDict["DKK"]!
                                c.rate = rate!
                                self.currencyDict["DKK"] = c
                            case "EUR":
                                let c:Currency = self.currencyDict["EUR"]!
                                c.rate = rate!
                                self.currencyDict["EUR"] = c
                            case "BGN":
                                let c:Currency = self.currencyDict["BGN"]!
                                c.rate = rate!
                                self.currencyDict["BGN"] = c
                            default:
                                print("Ignoring currency: \(String(describing: rate))")
                            }
                            
                            /*
                             let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
                             self.currencyDict[name] = c
                             */
                        }
                        self.lastUpdatedDate = Date()
                    }
                }
                catch let error as NSError{
                    print(error)
                }
            }
            else{
                print("Error")
            }
            
        }
            task.resume()
            indicator.stopAnimating()
    }
    
    @IBAction func convert(_ sender: Any? = nil) {
        var resultGBP = 0.0
        var resultUSD = 0.0
        var resultJPY = 0.0
        var resultAUD = 0.0
        var resultCAD = 0.0
        var resultPLN = 0.0
        var resultDKK = 0.0
        var resultEUR = 0.0
        var resultBGN = 0.0
        
        
        if let base = Double(baseTextField.text!) {
            convertValue = base
            if let gbp = self.currencyDict["GBP"] {
                resultGBP = convertValue * gbp.rate
            }
            if let usd = self.currencyDict["USD"] {
                resultUSD = convertValue * usd.rate
            }
            if let jpy = self.currencyDict["JPY"] {
                resultJPY = convertValue * jpy.rate
            }
            if let aud = self.currencyDict["AUD"] {
                resultAUD = convertValue * aud.rate
            }
            if let cad = self.currencyDict["CAD"] {
                resultCAD = convertValue * cad.rate
            }
            if let pln = self.currencyDict["PLN"] {
                resultPLN = convertValue * pln.rate
            }
            if let dkk = self.currencyDict["DKK"] {
                resultDKK = convertValue * dkk.rate
            }
            if let eur = self.currencyDict["EUR"] {
                resultEUR = convertValue * eur.rate
            }
            if let bgn = self.currencyDict["BGN"] {
                resultBGN = convertValue * bgn.rate
            }
        }
        //GBP
        
        //convertedLabel.text = String(describing: resultGBP)
        
        gbpValueLabel.text = String(format: "%.02f", resultGBP)
        usdValueLabel.text = String(format: "%.02f", resultUSD)
        jpyValueLabel.text = String(format: "%.02f", resultJPY)
        audValueLabel.text = String(format: "%.02f", resultAUD)
        cadValueLabel.text = String(format: "%.02f", resultCAD)
        plnValueLabel.text = String(format: "%.02f", resultPLN)
        dkkValueLabel.text = String(format: "%.02f", resultDKK)
        eurValueLabel.text = String(format: "%.02f", resultEUR)
        bgnValueLabel.text = String(format: "%.02f", resultBGN)
    }
    
    @IBAction func refresh(_ sender: Any) {
        getTable()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var current:Currency
        current = currencyDict[currencies[row]]!
        baseSymbol.text = current.symbol
        baseFlag.text = current.flag
        baseCurrency = current
        baseCurrency?.rate = 1
        getConversionTable()
        
        }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     
     }
     */
    
}

