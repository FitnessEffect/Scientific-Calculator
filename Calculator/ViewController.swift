//
//  ViewController.swift
//  Calculator
//
//  Created by Stefan Auvergne on 6/5/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultTextViewOutlet: UILabel!
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
    var dummy = true
    var entryStringWithoutLast = ""
    var entryStringWithoutLastTwo = ""
    var entryStringWithoutLastThree = ""
    var entryStringWithoutLastFour = ""
    var entryStringWithoutLastFive = ""
    var entryStringWithoutLastSix = ""
    var entryCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func result(sender: UIButton) {
        
        tempArray = entryString.componentsSeparatedByString(" ")
        
        convertToDoubles()
        
        checkForParenthesis()
        
        tempResult = priorityCalculation(tempArray)
        
        resultTextViewOutlet.text = String(tempResult)
        entryString = String(tempResult)
        num1 = tempResult
    }
    
    func checkForParenthesis(){
        
        for element in tempArray{
            if element.containsString("("){
                parenthesisHandling()
                break
            }
        }
    }
    
    func parenthesisHandling() -> [String]{
        
        var subArray:[String] = []
        
        subArray = decompose(tempArray)
        
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
            parenthesisHandling()
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
            parenthesisHandling()
        }
        if dummy == true{
            updateTempArray(firstIndex, lastI: lastIndex, array: subArray)
            checkForParenthesis()
            dummy = false
        }
        return tempArray
    }
    
    func updateTempArray(firstI:Int, lastI:Int, array:[String]){
        
        tempArray.removeRange(firstI...lastI)
        tempArray.insert(String(calculateInParenthesis(array)), atIndex: firstIndex)
    }
    
    func decompose(array:[String]) -> [String]{
        
        var subArray:[String] = []
        
        for element in array{
            if element.containsString("("){
                firstIndex = array.indexOf(element)!
            }
            
            if element.containsString(")"){
                lastIndex = array.indexOf(element)!
                break
            }
        }
        for x in firstIndex ..< (lastIndex+1){
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
        
        return priorityCalculation(subArray)
    }
    
    func convertToDoubles() -> [String]{
        
        for element in tempArray{
            let y = tempArray.indexOf(element)
            
            if element.containsString("^"){
                var array2 = element.componentsSeparatedByString("^")
                    for x in 0 ..< array2.count{
                        let y = Double(array2[x])!
                        array2[x] = String(y)
                    }
                tempArray.removeAtIndex(y!)
                tempArray.insert(array2[0] + "^" + array2[1], atIndex: y!)
            }
            if element.containsString("√"){
                var array2 = element.componentsSeparatedByString("√")
                for x in 1 ..< array2.count{
                    let y = Double(array2[x])!
                    array2[x] = String(y)
                }
                tempArray.removeAtIndex(y!)
                tempArray.insert(array2[0] + "√" + array2[1], atIndex: y!)
            }
        }
        return tempArray
    }
    
    func priorityCalculation(x:[String]) -> Double {
        
        var tempValue:Double = 0.0
        var array:[String] = []
        array = x
        
        for element in array{
            
            if element.containsString("√"){
                
                var root = 0.0
                
                let array2 = element.componentsSeparatedByString("√")
                
                if num1.isZero{
                    num1 = Double(array2.last!)!
                    root = sqrt(num1)
                    let tempString = "√" + String(Double(num1))
                    let y = array.indexOf(tempString)
                    array.removeAtIndex(y!)
                    array.insert(String(root), atIndex: y!)
                    num1 = root
                    
                }else{
                    num2 = Double(array2.last!)!
                    root = sqrt(num2)
                    let tempString = "√" + String(Double(num2))
                    let y = array.indexOf(tempString)
                    array.removeAtIndex(y!)
                    array.insert(String(root), atIndex: y!)
                    num2 = root
                }
            }
            
            if element.containsString("^"){
                
                let array2 = element.componentsSeparatedByString("^")
                
                let exp = Double(array2.last!)!
                let base = Double(array2.first!)!
                
                num1 = pow(base, exp)
                let tempString = String(Double(base)) + "^" + String(Double(exp))
                let y = array.indexOf(tempString)
                array.removeAtIndex(y!)
                array.insert(String(num1), atIndex: y!)
            }
        }
        
        if array.contains("x") || array.contains("/"){
            for element in array{
                
                if element == "x"{
                    
                    let x = array.indexOf("x")
                    num1 = Double(array[(x!-1)])!
                    num2 = Double(array[(x!+1)])!
                    array.removeAtIndex(Int(x!+1))
                    array.removeAtIndex(Int(x!))
                    array.removeAtIndex(Int(x!-1))
                    array.insert(String(num1 * num2), atIndex: x!-1)
                }
                if element == "/"{
                    let x = array.indexOf("/")
                    num1 = Double(array[(x!-1)])!
                    num2 = Double(array[(x!+1)])!
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
                    num1 = Double(array[(x!-1)])!
                    num2 = Double(array[(x!+1)])!
                    array.removeAtIndex(Int(x!+1))
                    array.removeAtIndex(Int(x!))
                    array.removeAtIndex(Int(x!-1))
                    array.insert(String(num1 + num2), atIndex: x!-1)
                }
                
                if element == "-"{
                    
                    let x = array.indexOf("-")
                    num1 = Double(array[(x!-1)])!
                    num2 = Double(array[(x!+1)])!
                    array.removeAtIndex(Int(x!+1))
                    array.removeAtIndex(Int(x!))
                    array.removeAtIndex(Int(x!-1))
                    array.insert(String(num1 - num2), atIndex: x!-1)
                }
            }
        }
        
        tempValue = Double(array[0])!
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