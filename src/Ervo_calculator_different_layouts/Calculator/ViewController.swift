//
//  ViewController.swift
//  Calculator
//
//  Created by Admin on 20.01.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    private var isUserTyping = false
    
    private var model = Model()
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }

    @IBAction private func onDigitButtonPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if (isUserTyping) {
            if (canAdd(symbol: digit)) {
                let currentDisplayText = display.text!
                display.text = currentDisplayText + digit
            }
        } else {
            display.text = digit
        }
        isUserTyping = true
    }
    
    @IBAction private func onOperationButtonPressed(_ sender: UIButton) {
        if isUserTyping {
            model.setOperand(operand: displayValue)
            isUserTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            model.performOperation(symbol: mathSymbol)
            displayValue = model.result
        }
    }
    
    private func canAdd(symbol: String) -> Bool {
        return (symbol != ".") || (!(display.text?.contains("."))!)
    }
}
