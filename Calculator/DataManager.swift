//
//  DataManager.swift
//  Calculator
//
//  Created by Enzo Garofalo on 11/11/16.
//  Copyright © 2016 Enzo Garofalo. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    static let emDash = Character("–")
    static let pipe = Character("|")
    static let endPipe = Character("!")
    static var dataManager = DataManager()
    
    var viewController: ViewController?
    
    var currentNumber: String = ""
    
    var currentOperation: String = ""
    
    var expression: String = ""
    
    var operands: [Double] = []
    var operations: [String] = []
    
    var parenthesisStack : [String] = []
    
    var equalPressed : Bool = false
    
    var infix2Rpn: Infix2ReversePolishNotation = Infix2ReversePolishNotation.instance
    
    var cancelOn = true
    
    var decimalPointPressed = false
    
    override private init() {
        super.init()
    }
    
    let operationButtons = [CalculatorKey.addition,CalculatorKey.subtraction,CalculatorKey.divisor,CalculatorKey.multiplication]

    let parenthesisButtons = [CalculatorKey.leftParenthesis,CalculatorKey.rightParenthesis]

    func initVars() {
        viewController!.expressionLabel.text! = ""
        viewController!.calcDisplayLabel.text! = ""
        currentNumber = ""
        currentOperation = ""
        operands = []
        operations = []
        parenthesisStack = []
        expression = ""
        decimalPointPressed = false
        lockUnlockCalculatorButtonsForType(lock: false, types: [CalculatorKey.rightParenthesis,CalculatorKey.minus,CalculatorKey.decimalPoint])
    }
    
   

    func manageInsertedData(calcButtonElement: String) {
        if let buttonPressed = CalculatorKey.fromValue(element: calcButtonElement) {
            if self.equalPressed {
                initVars()
                self.equalPressed = false
            }
            lockUnlockCalculatorButtonsForType(lock: false, types: parenthesisButtons)
            if buttonPressed.numericValue != nil || buttonPressed == .decimalPoint || buttonPressed == .minus{
                if buttonPressed != .minus {
                    if buttonPressed == .decimalPoint && (viewController!.calculatorButtonsMap[CalculatorKey.decimalPoint.rawValue]?.isUserInteractionEnabled)! {
                        lockUnlockCalculatorButtonsForType(lock: true, types: [CalculatorKey.decimalPoint])
                    }
                    currentNumber += calcButtonElement
                }
                
                if parenthesisCoherence() <= 0 {                    
                    lockUnlockCalculatorButtonsForType(lock: true, types: parenthesisButtons)
                } else {
                    lockUnlockCalculatorButtonsForType(lock: false, types: [CalculatorKey.rightParenthesis])
                }
                
                if buttonPressed == .minus {
                    if currentNumber.isEmpty {
                        currentNumber += String(DataManager.emDash)
                    } else {
                        let firstChar = currentNumber[currentNumber.index(currentNumber.startIndex, offsetBy: 0)]
                        if(firstChar != DataManager.emDash) {
                            currentNumber = String(DataManager.emDash) + currentNumber
                            debugPrint("currentNumber : "+currentNumber)
                        } else if(currentNumber.isEmpty == false && firstChar == DataManager.emDash) {
                            currentNumber.remove(at: currentNumber.startIndex)
                        }
                    }
                }

            } else {
                
                if buttonPressed == .delete {
                    //TODO : aggiungere gestione delete
                    if(!currentNumber.isEmpty) {
                        currentNumber=""
                    } else
                    // delete last
                    if let lastExprChar = expression.characters.last {
                        switch lastExprChar {
                        case "(": expression.characters.removeLast();
                            parenthesisStack.popLast()
                        case ")": expression.characters.removeLast();
                            parenthesisStack.popLast()
                        case "+","-","X",":":
                            expression.characters.removeLast();
                         case "!":
                            var lastPipe = expression.characters.last
                            while lastPipe != Character("|") {
                                expression.characters.removeLast()
                                lastPipe = expression.characters.last
                            }
                            lockUnlockCalculatorButtonsForType(lock: false, types: [CalculatorKey.decimalPoint])
                            decimalPointPressed = false
                        default:break
                        }
                        if lastExprChar == Character("(") || lastExprChar == Character(")") {
                            if parenthesisCoherence() <= 0 {
                                lockUnlockCalculatorButtonsForType(lock: false, types: [CalculatorKey.rightParenthesis,CalculatorKey.equal])
                            } else {
                                lockUnlockCalculatorButtonsForType(lock: true, types: [CalculatorKey.equal])
                            }
                        }
                    }
                    if !viewController!.expressionLabel.text!.isEmpty {
                        viewController!.expressionLabel.text!.characters.removeLast()
                        if Character("-") == viewController!.expressionLabel.text!.characters.last {
                            viewController!.expressionLabel.text!.characters.removeLast()
                        }
                    }

                } else {
                    
                    if !currentNumber.isEmpty {
                        expression += String(DataManager.pipe) + currentNumber + String(DataManager.endPipe)
                        currentNumber = ""
                        lockUnlockCalculatorButtonsForType(lock: false, types: [CalculatorKey.decimalPoint])
                    }
                    
                    if buttonPressed == .leftParenthesis || buttonPressed == .rightParenthesis {
                        if buttonPressed == .leftParenthesis {
                            parenthesisStack.append("op")
                        } else if buttonPressed == .rightParenthesis {
                            parenthesisStack.append("cp")
                        }
                        //expression += calcButtonElement
                        if parenthesisCoherence() <= 0 {
                            lockUnlockCalculatorButtonsForType(lock: false, types: [CalculatorKey.rightParenthesis,CalculatorKey.equal])
                        } else {
                            lockUnlockCalculatorButtonsForType(lock: true, types: [CalculatorKey.equal])
                        }
                    }
                    
                    if buttonPressed == .cancel {
                        initVars()
                    } else {
                        expression += calcButtonElement
                    }
                    
                    if buttonPressed == .equal {
                        debugPrint("expressione var :  "+expression)
                        let lbl = infix2Rpn.translate(expression: expression)
                        viewController!.calcDisplayLabel.text! = resultFromRpn(rpnExpression: lbl)
                        debugPrint(lbl)
                        self.equalPressed = true
                        expression = ""
                    }
                }
                

            }
            if buttonPressed != .cancel && buttonPressed != .equal  && buttonPressed != .minus && buttonPressed != .delete {
                    viewController!.expressionLabel.text! += calcButtonElement
            } else if buttonPressed != .equal {
                viewController!.expressionLabel.text! = expression.replacingOccurrences(of: "!", with: "")
                    .replacingOccurrences(of: "|", with: "")
                if buttonPressed == .minus {
                    viewController!.expressionLabel.text! += currentNumber
                }
            }
            /*else if buttonPressed == .minus {
                let lastChar = viewController!.expressionLabel.text!.characters.last
                if lastChar != nil {
                    viewController!.expressionLabel.text!.characters.removeLast()
                    viewController!.expressionLabel.text! += "-" + String(lastChar!)
                }
            }*/
            
            debugPrint("expression is : \(expression)")
            
        }
        
    }
    
    private func resultFromRpn(rpnExpression: String) -> String {
        var tmpNum = ""
        let operandStack: NumericStack = NumericStack()
        for item in rpnExpression.characters {
            let cKey = CalculatorKey.fromValue(element: String(item))
            if cKey != nil {
                switch cKey! {
                case .pipe:
                    if !tmpNum.isEmpty {
                        tmpNum = ""
                    }
                case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimalPoint, .minus, .littleMinus:
                    
                    if cKey != CalculatorKey.littleMinus {
                        tmpNum += String(item)
                    } else {
                        tmpNum += "-"
                    }
                case .endPipe:
                    if !tmpNum.isEmpty , let num = tmpNum.doubleValue {
                        operandStack.push(item: num)
                    }
                case .addition, .subtraction, .multiplication, .divisor:
                    if operandStack.stack.count > 1 {
                        if cKey == CalculatorKey.addition {
                            operandStack.push(item: operandStack.pop()! + operandStack.pop()!)
                        } else if cKey == CalculatorKey.subtraction {
                            operandStack.push(item: -1 * operandStack.pop()! + operandStack.pop()!)
                        } else if cKey == CalculatorKey.multiplication {
                            operandStack.push(item: operandStack.pop()! * operandStack.pop()!)
                        } else if cKey == CalculatorKey.divisor {
                            operandStack.push(item: (1 / operandStack.pop()!) * operandStack.pop()!)
                        }
                    }
                default : return "0.0"
                }
            }
        }
        let result = operandStack.pop()
        return result != nil ? "\(result!)" : "0.0"
    }
    
    private func parenthesisCoherence() -> Int {
        var openClosedItem: Int = 0
        for item in parenthesisStack {
            if item == "op" {
                openClosedItem += 1
            } else if item == "cp" {
                openClosedItem -= 1
            }
        }
        return openClosedItem
    }
    
    func lockUnlockCalculatorButtonsForType(lock: Bool,types :[CalculatorKey]) {
        for type in types {
            viewController!.calculatorButtonsMap[type.rawValue]?.isUserInteractionEnabled = !lock
            viewController!.calculatorButtonsMap[type.rawValue]?.backgroundColor = lock ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.0532637462, green: 0.2073364258, blue: 1, alpha: 1)
        }
    }
    
}
