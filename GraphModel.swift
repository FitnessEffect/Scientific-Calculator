//
//  GraphModel.swift
//  Calculator
///Users/stefanauvergne/Desktop/Swift Files/Scientific Calculator /GraphModel.swift
//  Created by Stefan Auvergne on 7/20/16.
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

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}


class GraphModel{
    
    var equation:String = ""
    var resultArray:[Double] = []
    fileprivate var tempArray = [String]()
    fileprivate var tempSubArray = [String]()
    fileprivate var locationOfX = 0
    fileprivate var locationOfV = 0
    let calcModel = CalculatorModel()
    var skip:Bool = false
    
    
    func parseAndCalculateYvalues(_ x:String, xMax:Double, xMin:Double, screenWidth:Double) -> [Double]{
        
        let deltaX:Double = (xMax - xMin)/Double(screenWidth)
        
        
        equation = x
        tempArray = equation.components(separatedBy: " ")
        for element in tempArray{
            if element.contains("x"){
                locationOfX = tempArray.index(of: element)!
            }
        }
        
        
        for element in tempArray{
            
            if element.contains("x"){
                
                
                for i in 0 ..< Int(screenWidth + 0.5) {
                    
                    tempSubArray = element.components(separatedBy: "x")
                    
                    var xValue = String(xMin + Double(i) * deltaX)
                    
                    if element.contains("^"){
                        tempSubArray.removeFirst()
                        tempSubArray.insert(xValue + tempSubArray.first! + ".0", at: tempSubArray.startIndex)
                        tempSubArray.removeLast()
                        tempArray = tempSubArray
                        
                    }else if element.contains("√"){
                        if Double(xValue) <= 0{
                            skip = true
                            resultArray.append(0)
                        }else{
                            skip = false
                            
                            xValue = tempSubArray.first! + xValue
                            tempSubArray.removeLast()
                            tempSubArray.insert(xValue, at: tempSubArray.startIndex)
                            tempSubArray.removeLast()
                            tempArray = tempSubArray
                        }
                        
                    }else if element.contains("cos") || element.contains("sin"){
                        xValue = tempSubArray.first! + xValue
                        tempSubArray.removeLast()
                        tempSubArray.insert(xValue, at: tempSubArray.startIndex)
                        tempSubArray.removeLast()
                        tempArray = tempSubArray
                        
                    }else{
                        tempSubArray.removeAll()
                        tempArray.remove(at: locationOfX)
                        tempArray.insert(xValue, at: locationOfX)
                        
                    }
                    if skip == false{
                        do{
                            if(resultArray.count < i + 1){
                                resultArray.append(0)
                            }
                            resultArray[i] = try calcModel.priorityCalculation(tempArray)
                        }catch CalculatorModel.error.invalidInput {
                            print("Input Error")
                        }catch{
                            print("Other Error")
                        }
                    }
                }
            }
        }
        return resultArray
    }
}
