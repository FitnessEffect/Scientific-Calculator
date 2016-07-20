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

    
    private var entryString:String = ""
    private var count = false
    private let n:Double = 0.0
    private var entryStringWithoutLast = ""
    private var entryStringWithoutLastTwo = ""
    private var entryStringWithoutLastThree = ""
    private var entryStringWithoutLastFour = ""
    private var entryStringWithoutLastFive = ""
    private var entryStringWithoutLastSix = ""
    private var entryCount = 0
    private var calculatorModel = CalculatorModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func result(sender: UIButton) {
        
        calculatorModel.setTempArray(entryString.componentsSeparatedByString(" "))
        
        do{
            try calculatorModel.convertToDoubles()
            try calculatorModel.checkForParenthesis()
            try calculatorModel.calculateTempResult()
            resultTextViewOutlet.text = String(calculatorModel.getTempResult())
            entryString = String(calculatorModel.getTempResult())
                        
        }catch CalculatorModel.Error.InvalidParenthesis{
            reset()
            resultTextViewOutlet.text = "Parenthesis Error"
            
        }catch CalculatorModel.Error.InvalidInput{
            reset()
            resultTextViewOutlet.text = "Input Error"
            
        }catch{
            print("Other error")
        }
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
        reset()
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
    
    func reset(){
        entryString = ""
        calculatorModel.setTempResult(0.0)
        calculatorModel.setTempArray([""])
    }
}