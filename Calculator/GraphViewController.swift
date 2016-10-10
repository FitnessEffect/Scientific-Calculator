//
//  GraphViewController.swift
//  Calculator
//
//  Created by Stefan Auvergne on 7/20/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var graphViewOutlet: GraphViewWindow!
    var function1 = ""
    var model = GraphModel()
    var pinchGesture = UIPinchGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set pinch gesture delegate
        self.pinchGesture.delegate = self
        
        // set pinch gesture target
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(GraphViewController.pinchRecognized(_:)))
        
        // add pinch gesture recognizer to view
        self.view.addGestureRecognizer(self.pinchGesture)
        
        graphViewOutlet.arrayOfYvalues = model.parseAndCalculateYvalues(function1, xMax: graphViewOutlet.xMax, xMin: graphViewOutlet.xMin, screenWidth: graphViewOutlet.screenWidth)
        graphViewOutlet.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        functionLabel.text = function1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pinchRecognized(_ pinch: UIPinchGestureRecognizer) {
        
        graphViewOutlet.xMax = graphViewOutlet.xMax /  Double(pinch.scale)
        graphViewOutlet.xMin = graphViewOutlet.xMin /  Double(pinch.scale)
        
        graphViewOutlet.yMax = graphViewOutlet.yMax /  Double(pinch.scale)
        graphViewOutlet.yMin = graphViewOutlet.yMin /  Double(pinch.scale)
        
        graphViewOutlet.xUnit = graphViewOutlet.xUnit / Double(pinch.scale)
        graphViewOutlet.yUnit = graphViewOutlet.yUnit / Double(pinch.scale)
        
        print(graphViewOutlet.xMax)
        graphViewOutlet.arrayOfYvalues = model.parseAndCalculateYvalues(function1, xMax: graphViewOutlet.xMax, xMin: graphViewOutlet.xMin, screenWidth: graphViewOutlet.screenWidth)
        
        graphViewOutlet.setNeedsDisplay()
        pinch.scale = 1.0
        
    }
    

    func setUpGraph(_ string:String?){
       function1 = string!
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
