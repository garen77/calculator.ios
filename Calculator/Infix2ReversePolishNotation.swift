//
//  Infix2ReversePolishNotation.swift
//  Calculator
//
//  Created by Enzo Garofalo on 17/11/16.
//  Copyright © 2016 Enzo Garofalo. All rights reserved.
//

import UIKit

enum CalculatorKey: Int {
    
    case cancel = 1
    case minus
    case divisor
    case addition
    case subtraction
    case multiplication
    case decimalPoint
    case equal
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case leftParenthesis
    case rightParenthesis
    case littleMinus
    case pipe
    case endPipe
    case delete
    
    var numericValue : Int? {
        switch self {
        case .zero: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        default: return nil
        }
    }
    
    var operationValue: String? {
        switch self {
        case .addition: return "+"
        case .multiplication: return "*"
        case .divisor: return "/"
        case .subtraction: return "-"
        default: return nil
        }
    }
    
    var precedence: Int {
        switch self {
        case .addition: return 1
        case .subtraction: return 1
        case .multiplication: return 2
        case .divisor: return 2
        default: return 0
        }
    }
    
    static func fromValue(element: String) -> CalculatorKey? {
        switch element {
        case "0": return .zero
        case "1": return .one
        case "2": return .two
        case "3": return .three
        case "4": return .four
        case "5": return .five
        case "6": return .six
        case "7": return .seven
        case "8": return .eight
        case "9": return .nine
        case "C": return .cancel
        case "+/-": return .minus
        case ":": return .divisor
        case "+": return .addition
        case "-": return .subtraction
        case "=": return .equal
        case "X": return .multiplication
        case ".": return .decimalPoint
        case "(": return .leftParenthesis
        case ")": return .rightParenthesis
        case String(DataManager.emDash): return .littleMinus
        case String(DataManager.pipe): return .pipe
        case "!": return .endPipe
        case "<": return .delete
        default: return nil
        }
    }
}



class Stack {
    
    var stack : [String] = []
    
    func push(item: String) {
        self.stack.append(item)
    }
    
    func pop() -> String? {
        let last = self.stack.last
        if last != nil {
            self.stack.removeLast()
        }
        return last
    }
    
    func viewTop() -> String? {
        return self.stack.last
    }
    
    func print(type: String) {
        debugPrint("stack \(type) : ")
        for itm in self.stack {
            debugPrint("\(itm)")
        }
    }
    
    
}

class NumericStack {
    var stack: [Double] = []
    
    func push(item: Double) {
        self.stack.append(item)
    }
    
    func pop() -> Double? {
        let last = self.stack.last
        if last != nil{
            self.stack.removeLast()
        }
        return last
    }

    func print() {
        debugPrint("numeric stack : ")
        for itm in self.stack {
            debugPrint("\(itm)")
        }
    }

 
}

extension String {
    var doubleValue : Double? {
        return Double(self)
    }
}

class Infix2ReversePolishNotation: NSObject {
    
    static var instance: Infix2ReversePolishNotation = Infix2ReversePolishNotation()
    
    override private init() {
        
    }

    func translate(expression: String) -> String {
        var res = ""
        if expression.isEmpty {
            return ""
        } else {
            
            let operatorStack: Stack = Stack()
            
            for item in expression.characters {
                //TODO: parse infix notation expression
                let cKey = CalculatorKey.fromValue(element: String(item))
                if cKey != nil {
                    switch cKey! {
                    case .addition, .subtraction, .multiplication, .divisor:
                        
                        while operatorStack.viewTop() != nil && CalculatorKey.fromValue(element: operatorStack.viewTop()!)?.operationValue != nil {
                            if CalculatorKey.fromValue(element: operatorStack.viewTop()!)!.precedence >= cKey!.precedence {
                                res += operatorStack.pop()!
                            } else {
                                break
                            }
                        }
                        operatorStack.push(item: String(item))
                        
                    case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimalPoint, .minus, .littleMinus, .pipe, .endPipe:
                        res += String(item)
                    case .leftParenthesis:
                        operatorStack.push(item: String(item))
                    case .rightParenthesis:
                        while CalculatorKey.fromValue(element: operatorStack.viewTop() != nil ? operatorStack.viewTop()! : "") != .leftParenthesis {
                            if let operatorOnTop = operatorStack.pop() {
                                res += operatorOnTop
                            }
                        }
                        operatorStack.pop()
                    case .equal:
                        if let operatorOnTop = operatorStack.pop() {
                            res += operatorOnTop
                        }
                    case .cancel, .delete:
                        return ""
                    }
                    debugPrint("-------------------")
                    debugPrint("character : \(item)")
                    operatorStack.print(type: "operand stack")
                }
            }
            return res
        }
    }
    
    
}
