//
//  Model.swift
//  Calculator
//
//  Created by Admin on 20.01.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import Foundation

class Model {
    private var accumulator = 0.0
    private var pendingBinaryOperationInfo: PendingBinaryOperationInfo?
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations = [
        "π"   : Operation.Constant(M_PI),
        "√"   : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "+"   : Operation.BinaryOperation({$0 + $1}),
        "-"   : Operation.BinaryOperation({$0 - $1}),
        "×"   : Operation.BinaryOperation({$0 * $1}),
        "÷"   : Operation.BinaryOperation({$0 / $1}),
        "="   : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let constantValue): accumulator = constantValue
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                performEqualsOperation()
                pendingBinaryOperationInfo = PendingBinaryOperationInfo(function: function, value: accumulator)
            case .Equals: performEqualsOperation()
            }
        }
    }
    
    private func performEqualsOperation() {
        if pendingBinaryOperationInfo != nil {
            accumulator = pendingBinaryOperationInfo!.function(pendingBinaryOperationInfo!.value, accumulator)
            pendingBinaryOperationInfo = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    private struct PendingBinaryOperationInfo {
        var function: (Double, Double) -> Double
        var value: Double
    }
}
