//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Simon Zhen on 4/5/17.
//  Copyright © 2017 Simon Zhen. All rights reserved.
//

import UIKit
import AVFoundation

class CalcVC: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var reset = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
        outputLbl.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        if reset {
            leftValStr = ""
            rightValStr = ""
        }
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
        
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
        reset = true
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        resetCalc()
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        
        reset = false
        
        if currentOperation != Operation.Empty && !leftValStr.isEmpty {
            
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
            
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = operation
        }
        else {
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
            print( currentOperation )
        }
    }
    
    func resetCalc() {
        runningNumber = ""
        outputLbl.text = "0"
        leftValStr = ""
        rightValStr = ""
        //reset = true
    }
}

