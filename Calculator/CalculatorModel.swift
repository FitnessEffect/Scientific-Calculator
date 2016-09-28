//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Stefan Auvergne on 7/7/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}


class CalculatorModel{
    
    fileprivate var tempResult = 0.0
    fileprivate var tempArray = [""]
    fileprivate var num1:Double = 0.0
    fileprivate var num2:Double = 0.0
    fileprivate var subArray:[String] = []
    fileprivate var firstIndex = 0
    fileprivate var lastIndex = 0
    fileprivate var skip = true
    
    func setTempArray(_ a:[String]){
        tempArray = a
    }
    
    func getTempResult() -> Double{
        return tempResult
    }
    
    func setTempResult(_ num:Double){
        tempResult = num
    }
    
    func removeSingleParenthesis(_ string:String) throws -> [String]{
        var x = string.components(separatedBy: "(")
        x.removeFirst()
        
        x = x[0].components(separatedBy: ")")
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
            
            
            let y = tempArray.index(of: element)
            
            if element.contains("^"){
                
                
                var array2 = element.components(separatedBy: "^")
                for x in 0 ..< array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.remove(at: y!)
                tempArray.insert(array2[0] + "^" + array2[1], at: y!)
            }
            if element.contains("√"){
                var array2 = element.components(separatedBy: "√")
                for x in 1 ..< array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.remove(at: y!)
                tempArray.insert(array2[0] + "√" + array2[1], at: y!)
            }
            if element.contains("cos"){
                var array2 = element.components(separatedBy: "cos")
                for x in 1..<array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.remove(at: y!)
                tempArray.insert(array2[0] + "cos" + array2[1], at: y!)
            }
            
            if element.contains("sin"){
                var array2 = element.components(separatedBy: "sin")
                for x in 1..<array2.count{
                    let y = try stringToDouble(array2[x])
                    array2[x] = String(y)
                }
                tempArray.remove(at: y!)
                tempArray.insert(array2[0] + "sin" + array2[1], at: y!)
            }
        }
        return tempArray
    }
    
    func stringToDouble(_ string:String) throws -> Double{
        
        if let num1 = Double(string){
            return num1
        }else{
            throw error.invalidInput
        }
    }
    
    func priorityCalculation(_ x:[String]) throws -> Double {
        
        var tempValue:Double = 0.0
        var array:[String] = []
        array = x
        
        for element in array{
            
            if element.contains("√"){
                
                var root = 0.0
                
                let array2 = element.components(separatedBy: "√")
                
                if num1.isZero{
                    try num1 = stringToDouble(array2.last!)
                    root = sqrt(num1)
                    let tempString = "√" + String(num1)
                    let y = array.index(of: tempString)
                    array.remove(at: y!)
                    array.insert(String(root), at: y!)
                    num1 = root
                    
                }else{
                    try num2 = stringToDouble(array2.last!)
                    root = sqrt(num2)
                    let tempString = "√" + String(num2)
                    let y = array.index(of: tempString)
                    array.remove(at: y!)
                    array.insert(String(root), at: y!)
                    num2 = root
                }
            }
            
            if element.contains("^"){
                
                let array2 = element.components(separatedBy: "^")
                
                let exp = try stringToDouble(array2.last!)
                let base = try stringToDouble(array2.first!)
                
                num1 = pow(base, exp)
                let tempString = String(base) + "^" + String(exp)
                let y = array.index(of: tempString)
                array.remove(at: y!)
                array.insert(String(num1), at: y!)
            }
        }
        
        for element in array{
            
            if element.contains("cos"){
                
                let array2 = element.components(separatedBy: "cos")
                let num1 = try stringToDouble(array2.last!)
                let cosResult = cos(num1)
                let tempString = "cos" + String(num1)
                let y = array.index(of: tempString)
                array.remove(at: y!)
                array.insert(String(cosResult), at: y!)
                
            }
            
            if element.contains("sin"){
                
                let array2 = element.components(separatedBy: "sin")
                let num1 = try stringToDouble(array2.last!)
                let cosResult = sin(num1)
                let tempString = "sin" + String(num1)
                let y = array.index(of: tempString)
                array.remove(at: y!)
                array.insert(String(cosResult), at: y!)
                
            }
        }
        
        if array.contains("*") || array.contains("/"){
            for element in array{
                
                if element == "*"{
                    
                    let x = array.index(of: "*")
                    num1 = try stringToDouble(array[(x!-1)])
                    num2 = try stringToDouble(array[(x!+1)])
                    array.remove(at: Int(x!+1))
                    array.remove(at: Int(x!))
                    array.remove(at: Int(x!-1))
                    array.insert(String(num1 * num2), at: x!-1)
                }
                if element == "/"{
                    let x = array.index(of: "/")
                    num1 = try stringToDouble(array[(x!-1)])
                    num2 = try stringToDouble(array[(x!+1)])
                    array.remove(at: Int(x!+1))
                    array.remove(at: Int(x!))
                    array.remove(at: Int(x!-1))
                    array.insert(String(num1 / num2), at: x!-1)
                }
                if !array.contains("/") && !array.contains("*") && !array.contains("√"){
                    break
                }
            }
        }
        
        if array.contains("+") || array.contains("-"){
            for element in array{
                if element == "+"{
                    
                    let x = array.index(of: "+")
                    try num1 = stringToDouble(array[(x!-1)])
                    try num2 = stringToDouble(array[(x!+1)])
                    array.remove(at: Int(x!+1))
                    array.remove(at: Int(x!))
                    array.remove(at: Int(x!-1))
                    array.insert(String(num1 + num2), at: x!-1)
                }
                
                if element == "-"{
                    
                    let x = array.index(of: "-")
                    try num1 = stringToDouble(array[(x!-1)])
                    try num2 = stringToDouble(array[(x!+1)])
                    array.remove(at: Int(x!+1))
                    array.remove(at: Int(x!))
                    array.remove(at: Int(x!-1))
                    array.insert(String(num1 - num2), at: x!-1)
                }
            }
        }
        tempValue = try stringToDouble(array[0])
        return tempValue
    }
    
    func calculateInParenthesis(_ subArrayPassed:[String]) -> Double{
        
        var subArray = subArrayPassed
        let x = subArray.first?.components(separatedBy: "(")
        let x1 = x?.last
        subArray.removeFirst()
        subArray.insert(x1!, at: 0)
        let y = subArray.last?.components(separatedBy: ")")
        let y1 = y?.first
        subArray.removeLast()
        subArray.insert(y1!, at: subArray.count)
        
        do{
            return try priorityCalculation(subArray)
        }catch{
            return 0.0
        }
    }
    
    
    func checkForParenthesis() throws{
        
        for element in tempArray{
            if element.contains("("){
                _ = try parenthesisHandling()
                break
            }
        }
    }
    
    func parenthesisHandling() throws -> [String]{
        
        
        _ = try decompose(tempArray)
        
        for element in tempArray{
            if element.contains("("){
                
                let checkParenthesis = subArray[0].components(separatedBy: "(")
                let checkParenthesisEnd = subArray.last?.components(separatedBy: ")")
                
                if checkParenthesisEnd?.count >= 3{
                    subArray.removeLast()
                    subArray.insert((checkParenthesisEnd?.first!)! + ")", at: Int(subArray.count))
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
                    subArray.insert(element, at: subArray.count)
                    tempArray.removeSubrange(firstIndex...lastIndex)
                    tempArray.insert(subArray.first!, at: firstIndex)
                    _ = try parenthesisHandling()
                }
                
                if checkParenthesis.count >= 3{
                    
                    subArray.removeFirst()
                    subArray.insert("(" + checkParenthesis.last!, at: Int(0))
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
                    subArray.insert(element, at: Int(0))
                    tempArray.removeSubrange(firstIndex...lastIndex)
                    tempArray.insert(subArray.first!, at: firstIndex)
                    _ = try parenthesisHandling()
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
    
    func updateTempArray(_ firstI:Int, lastI:Int, array:[String]){
        
        tempArray.removeSubrange(firstI...lastI)
        tempArray.insert(String(calculateInParenthesis(array)), at: firstIndex)
    }
    
    func decompose(_ array:[String]) throws-> [String]{
        
        
        
        for element in array{
            if element.contains("("){
                firstIndex = array.index(of: element)!
            }
            
            if element.contains(")"){
                lastIndex = array.index(of: element)!
                break
            }
        }
        
        if firstIndex == lastIndex{
            _ = try removeSingleParenthesis(array[firstIndex])
        }
        
        _ = try composeSubParenthesis(tempArray)
        
        
        return subArray
    }
    
    func composeSubParenthesis(_ array:[String]) throws -> [String]{
        
        
        subArray.removeAll()
        
        for x in firstIndex ..< (lastIndex+1){
            if lastIndex >= array.count{
                throw error.invalidParenthesis
            }
            
            let temp = array[x]
            subArray.append(temp)
        }
        
        return subArray
    }
    
    enum error:Error {
        case invalidInput
        case invalidParenthesis
    }
}
