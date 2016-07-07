//
//  ViewController.swift
//  Calculator
//
//  Created by Stefan Auvergne on 6/5/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var resultTextViewOutlet: UITextView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var times: UIButton!
    @IBOutlet weak var divide: UIButton!
    @IBOutlet weak var root: UIButton!
    @IBOutlet weak var squareNum: UIButton!
    @IBOutlet weak var savedValue1: UILabel!
    @IBOutlet weak var savedValue2: UILabel!
    @IBOutlet weak var negativeNum: UIButton!
    @IBOutlet weak var leftParenthesis: UIButton!
    @IBOutlet weak var rightParenthesis: UIButton!
    @IBOutlet weak var dot: UIButton!
    @IBOutlet weak var cosine: UIButton!
    @IBOutlet weak var sine: UIButton!

    
    var entryString:String = ""
    let prefs = NSUserDefaults.standardUserDefaults()
    var count = false
    let n:Double = 0.0
    var tempArray = [""]
    var num1:Double = 0.0
    var num2:Double = 0.0
    var storeFirstValue = false
    var tempResult = 0.0
    var firstIndex = 0
    var lastIndex = 0
    var skip = true
    var entryStringWithoutLast = ""
    var entryStringWithoutLastTwo = ""
    var entryStringWithoutLastThree = ""
    var entryStringWithoutLastFour = ""
    var entryStringWithoutLastFive = ""
    var entryStringWithoutLastSix = ""
    var entryCount = 0
    var subArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func result(sender: UIButton) {
        
        tempArray = entryString.componentsSeparatedByString(" ")
        
        do{
            try convertToDoubles()
            try checkForParenthesis()
            tempResult = try priorityCalculation(tempArray)
            resultTextViewOutlet.text = String(tempResult)
            entryString = String(tempResult)
            num1 = tempResult
            
        }catch Error.InvalidParenthesis{
            entryString = ""
            tempArray = [""]
            tempResult = 0.0
            resultTextViewOutlet.text = "Parenthesis Error"
            
        }catch Error.InvalidInput{
            entryString = ""
            tempArray = [""]
            tempResult = 0.0
            resultTextViewOutlet.text = "Input Error"
            
        }catch{
            print("Other error")
        }
    }
    
    func checkForParenthesis() throws{
        
        for element in tempArray{
            if element.containsString("("){
               try parenthesisHandling()
                break
            }
        }
    }
    
    func parenthesisHandling() throws -> [String]{
        
        
           try decompose(tempArray)
        

        let checkParenthesis = subArray[0].componentsSeparatedByString("(")
        let checkParenthesisEnd = subArray.last?.componentsSeparatedByString(")")
        
        if checkParenthesisEnd?.count >= 3{
            subArray.removeLast()
            subArray.insert((checkParenthesisEnd?.first!)! + ")", atIndex: Int(subArray.count))
            let v = calculateInParenthesis(subArray)
            subArray.removeAll()
            var element = ""
            if checkParenthesisEnd?.count == 3{
                element = String(v) + ")"
            }else if checkParenthesisEnd?.count == 4{
                element = String(v) + "))"
            }else if checkParenthesisEnd?.count == 5{
                element = String(v) + ")))"
            }else if checkParenthesisEnd?.count == 5{
                element = String(v) + "))))"
            }
            subArray.insert(element, atIndex: subArray.count)
            tempArray.removeRange(firstIndex...lastIndex)
            tempArray.insert(subArray.first!, atIndex: firstIndex)
            try parenthesisHandling()
        }
        
        if checkParenthesis.count >= 3{
            
            subArray.removeFirst()
            subArray.insert("(" + checkParenthesis.last!, atIndex: Int(0))
            let v = calculateInParenthesis(subArray)
            
            subArray.removeAll()
            var element = ""
            if checkParenthesis.count == 3 {
                element = "(" + String(v)
            } else if checkParenthesis.count == 4{
                element = "((" + String(v)
            }else if checkParenthesis.count == 5{
                element = "(((" + String(v)
            }else if checkParenthesis.count == 5{
                element = "((((" + String(v)
            }
            subArray.insert(element, atIndex: Int(0))
            tempArray.removeRange(firstIndex...lastIndex)
            tempArray.insert(subArray.first!, atIndex: firstIndex)
            try parenthesisHandling()
        }
        if skip == true{
            updateTempArray(firstIndex, lastI: lastIndex, array: subArray)
            try checkForParenthesis()
            skip = false
        }
        return tempArray
    }
    
    func updateTempArray(firstI:Int, lastI:Int, array:[String]){
        
        tempArray.removeRange(firstI...lastI)
        tempArray.insert(String(calculateInParenthesis(array)), atIndex: firstIndex)
    }
    
    func decompose(array:[String]) throws-> [String]{
        
        
        
        for element in array{
            if element.containsString("("){
                firstIndex = array.indexOf(element)!
            }
            
            if element.containsString(")"){
                lastIndex = array.indexOf(element)!
                break
            }
        }
        
        try composeSubParenthesis(array)
        
        
        return subArray
    }
    
    func composeSubParenthesis(array:[String]) throws -> [String]{
        
        subArray.removeAll()
        
        
        for x in firstIndex ..< (lastIndex+1){
            if lastIndex >= array.count{
               throw Error.InvalidParenthesis
            }
            
            let temp = array[x]
            subArray.append(temp)
            
           
        }
        
        return subArray
    }
        
    func calculateInParenthesis(subArrayPassed:[String]) -> Double{
        
        var subArray = subArrayPassed
        let x = subArray.first?.componentsSeparatedByString("(")
        let x1 = x?.last
        subArray.removeFirst()
        subArray.insert(x1!, atIndex: 0)
        let y = subArray.last?.componentsSeparatedByString(")")
        let y1 = y?.first
        subArray.removeLast()
        subArray.insert(y1!, atIndex: subArray.count)
        
        do{
            return try priorityCalculation(subArray)
        }catch{
            return 0.0
        }
    }
    
    func convertToDoubles() throws -> [String]{
        
        for element in tempArray{
            let y = tempArray.indexOf(element)
            
            if element.containsString("^"){
                var array2 = element.componentsSeparatedByString("^")
                for x in 0 ..< array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.removeAtIndex(y!)
                tempArray.insert(array2[0] + "^" + array2[1], atIndex: y!)
            }
            if element.containsString("√"){
                var array2 = element.componentsSeparatedByString("√")
                for x in 1 ..< array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.removeAtIndex(y!)
                tempArray.insert(array2[0] + "√" + array2[1], atIndex: y!)
            }
            if element.containsString("cos"){
                var array2 = element.componentsSeparatedByString("cos")
                for x in 1..<array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.removeAtIndex(y!)
                tempArray.insert(array2[0] + "cos" + array2[1], atIndex: y!)
            }
            
            if element.containsString("sin"){
                var array2 = element.componentsSeparatedByString("sin")
                for x in 1..<array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.removeAtIndex(y!)
                tempArray.insert(array2[0] + "sin" + array2[1], atIndex: y!)
            }
        }
        return tempArray
    }
    
    func stringToDouble(string:String) throws -> Double{
        
        if let num1 = Double(string){
            return num1
        }else{
            throw Error.InvalidInput
        }
    }
    
    enum Error: ErrorType {
        case InvalidInput
        case InvalidParenthesis
    }
    
    func priorityCalculation(x:[String]) throws -> Double {
        
        var tempValue:Double = 0.0
        var array:[String] = []
        array = x
        
        for element in array{
            
            if element.containsString("√"){
                
                var root = 0.0
                
                let array2 = element.componentsSeparatedByString("√")
                
                if num1.isZero{
                    try num1 = stringToDouble(array2.last!)
                    root = sqrt(num1)
                    let tempString = "√" + String(num1)
                    let y = array.indexOf(tempString)
                    array.removeAtIndex(y!)
                    array.insert(String(root), atIndex: y!)
                    num1 = root
                    
                }else{
                    try num2 = stringToDouble(array2.last!)
                    root = sqrt(num2)
                    let tempString = "√" + String(num2)
                    let y = array.indexOf(tempString)
                    array.removeAtIndex(y!)
                    array.insert(String(root), atIndex: y!)
                    num2 = root
                }
            }
            
            if element.containsString("^"){
                
                let array2 = element.componentsSeparatedByString("^")
                
                let exp = try stringToDouble(array2.last!)
                let base = try stringToDouble(array2.first!)
                
                num1 = pow(base, exp)
                let tempString = String(base) + "^" + String(exp)
                let y = array.indexOf(tempString)
                array.removeAtIndex(y!)
                array.insert(String(num1), atIndex: y!)
            }
        }
        
        for element in array{
            
                if element.containsString("cos"){
            
                    let array2 = element.componentsSeparatedByString("cos")
                    let num1 = try stringToDouble(array2.last!)
                    let cosResult = cos(num1 * M_PI / 180)
                    let tempString = "cos" + String(num1)
                    let y = array.indexOf(tempString)
                    array.removeAtIndex(y!)
                    array.insert(String(cosResult), atIndex: y!)
                
                }
            
            if element.containsString("sin"){
                
                let array2 = element.componentsSeparatedByString("sin")
                let num1 = try stringToDouble(array2.last!)
                let cosResult = sin(num1 * M_PI / 180)
                let tempString = "sin" + String(num1)
                let y = array.indexOf(tempString)
                array.removeAtIndex(y!)
                array.insert(String(cosResult), atIndex: y!)
                
            }
        }
        
        if array.contains("x") || array.contains("/"){
            for element in array{
                
                if element == "x"{
                    
                    let x = array.indexOf("x")
                    num1 = try stringToDouble(array[(x!-1)])
                    num2 = try stringToDouble(array[(x!+1)])
                    array.removeAtIndex(Int(x!+1))
                    array.removeAtIndex(Int(x!))
                    array.removeAtIndex(Int(x!-1))
                    array.insert(String(num1 * num2), atIndex: x!-1)
                }
                if element == "/"{
                    let x = array.indexOf("/")
                    num1 = try stringToDouble(array[(x!-1)])
                    num2 = try stringToDouble(array[(x!+1)])
                    array.removeAtIndex(Int(x!+1))
                    array.removeAtIndex(Int(x!))
                    array.removeAtIndex(Int(x!-1))
                    array.insert(String(num1 / num2), atIndex: x!-1)
                }
                if !array.contains("/") && !array.contains("x") && !array.contains("√"){
                    break
                }
            }
        }
        
        if array.contains("+") || array.contains("-"){
            for element in array{
                if element == "+"{
                    
                    let x = array.indexOf("+")
                    try num1 = stringToDouble(array[(x!-1)])
                    try num2 = stringToDouble(array[(x!+1)])
                    array.removeAtIndex(Int(x!+1))
                    array.removeAtIndex(Int(x!))
                    array.removeAtIndex(Int(x!-1))
                    array.insert(String(num1 + num2), atIndex: x!-1)
                }
                
                if element == "-"{
                    
                    let x = array.indexOf("-")
                    try num1 = stringToDouble(array[(x!-1)])
                    try num2 = stringToDouble(array[(x!+1)])
                    array.removeAtIndex(Int(x!+1))
                    array.removeAtIndex(Int(x!))
                    array.removeAtIndex(Int(x!-1))
                    array.insert(String(num1 - num2), atIndex: x!-1)
                }
            }
        }
        tempValue = try stringToDouble(array[0])
        return tempValue
    }
    
    @IBAction func keysButton(sender: UIButton) {
        
        var value:String = ""
        
        if  sender == button1{
            value = "1"
        }else if sender == button2{
            value = "2"
        }else if sender == button3{
            value = "3"
        }else if sender == button4{
            value = "4"
        }else if sender == button5{
            value = "5"
        }else if sender == button6{
            value = "6"
        }else if sender == button7{
            value = "7"
        }else if sender == button8{
            value = "8"
        }else if sender == button9{
            value = "9"
        }else if sender == button0{
            value = "0"
        }else if sender == plus{
            value = " + "
        }else if sender == minus{
            value = " - "
        }else if sender == times{
            value = " x "
        }else if sender == divide{
            value = " / "
        }else if sender == root{
            value = "√"
        }else if sender == squareNum{
            value = "^"
        }else if sender == negativeNum{
            value = "-"
        }else if sender == leftParenthesis{
            value = "("
        }else if sender == rightParenthesis{
            value = ")"
        }else if sender == dot{
            value = "."
        }else if sender == cosine{
            value = "cos"
        }else if sender == sine{
            value = "sin"
        }
        
        entryStringWithoutLastSix = entryStringWithoutLastFive
        entryStringWithoutLastFive = entryStringWithoutLastFour
        entryStringWithoutLastFour = entryStringWithoutLastThree
        entryStringWithoutLastThree = entryStringWithoutLastTwo
        entryStringWithoutLastTwo = entryStringWithoutLast
        entryStringWithoutLast = entryString
        
        entryString.appendContentsOf(value)
        resultTextViewOutlet.text = entryString
    }
    
    @IBAction func saveButton(sender: UIButton) {
        
        if count == false{
            savedValue1.text = String(entryString)
            count = true
        }else if count == true{
            savedValue2.text = String(entryString)
            count = false
        }
    }
    
    @IBAction func clearButton(sender: UIButton) {
        entryString = ""
        tempResult = 0
        resultTextViewOutlet.text = "0"
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        if entryCount == 0{
            entryString = entryStringWithoutLast
        }
        if entryCount == 1{
            entryString = entryStringWithoutLastTwo
        }
        if entryCount == 2{
            entryString = entryStringWithoutLastThree
        }
        if entryCount == 3{
            entryString = entryStringWithoutLastFour
        }
        if entryCount == 4{
            entryString = entryStringWithoutLastFive
        }
        if entryCount == 5{
            entryString = entryStringWithoutLastSix
        }
        resultTextViewOutlet.text = entryString
        entryCount += 1
    }
}