//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Stefan Auvergne on 7/7/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import Foundation

class CalculatorModel{
    
    private var tempResult = 0.0
    private var tempArray = [""]
    private var num1:Double = 0.0
    private var num2:Double = 0.0
    private var subArray:[String] = []
    private var firstIndex = 0
    private var lastIndex = 0
    private var skip = true
   
    func setTempArray(a:[String]){
        tempArray = a
    }
    
    func getTempResult() -> Double{
        return tempResult
    }
    
    func setTempResult(num:Double){
        tempResult = num
    }
    
    func removeSingleParenthesis(string:String) throws -> [String]{
        var x = string.componentsSeparatedByString("(")
        x.removeFirst()
        
        x = x[0].componentsSeparatedByString(")")
        x.removeLast()
        tempArray[firstIndex] = x.first!
        
        return tempArray
    }
    
    func calculateTempResult() throws{
        tempResult = try priorityCalculation(tempArray)
        num1 = tempResult
    }
    
    func convertToDoubles() throws -> [String]{
        
        try checkForParenthesis()
        
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
        
        for element in tempArray{
            if element.containsString("("){
                
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
            }
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
        
        if firstIndex == lastIndex{
                try removeSingleParenthesis(array[firstIndex])
            }
        
        try composeSubParenthesis(tempArray)
        
        
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
    
    enum Error: ErrorType {
        case InvalidInput
        case InvalidParenthesis
    }
}