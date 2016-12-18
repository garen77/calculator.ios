//
//  ViewController.swift
//  Calculator
//
//  Created by Enzo Garofalo on 09/11/16.
//  Copyright © 2016 Enzo Garofalo. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet var calcDisplayLabel: UIVerticalAlignLabel!
    @IBOutlet var expressionLabel: UILabel!
    
    
    @IBOutlet var calculatorButtons: [UILabel]!
    
    var calculatorButtonsMap : [Int:UILabel] = [:]
    
    let buttonPressedAnimation = CAKeyframeAnimation(keyPath: "transform.scale")

    let buttonYRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
    
    let buttonXRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
    
    let buttonZRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    
    func initButtonAnimation() {
        buttonXRotationAnimation.fromValue = 0.0
        buttonXRotationAnimation.toValue = M_PI * 2
        buttonXRotationAnimation.repeatCount = 1
        buttonXRotationAnimation.duration = 0.3

        buttonYRotationAnimation.fromValue = 0.0
        buttonYRotationAnimation.toValue = M_PI * 2
        buttonYRotationAnimation.repeatCount = 1
        buttonYRotationAnimation.duration = 0.3

        buttonZRotationAnimation.fromValue = 0.0
        buttonZRotationAnimation.toValue = M_PI * 2
        buttonZRotationAnimation.repeatCount = 1
        buttonZRotationAnimation.duration = 0.3

        var transform = CATransform3DIdentity
        transform.m34 = 1.0/500.0
        
    }

    func initAnimations() {
        buttonPressedAnimation.keyTimes = [0.0,0.5,1.0]
        buttonPressedAnimation.values = [0.0,0.8,1.0]
        buttonPressedAnimation.duration = 0.05
        buttonPressedAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DataManager.dataManager.viewController = self
        initButtonAnimation()
        calcDisplayLabel.verticalAlignment = .VerticalAlignmentBottom
        
        for calculatorButton in calculatorButtons {
            calculatorButton.layer.borderWidth = CGFloat(integerLiteral: 3)
            calculatorButton.layer.borderColor = UIColor.cyan.cgColor
            
            let tapGestureForCalcButton = UITapGestureRecognizer(target: self, action: #selector(selectCalculatorButton))
            tapGestureForCalcButton.numberOfTapsRequired = 1
            
            calculatorButton.isUserInteractionEnabled = true
            calculatorButton.addGestureRecognizer(tapGestureForCalcButton)
            
            calculatorButtonsMap[CalculatorKey.fromValue(element: calculatorButton.text!)!.rawValue] = calculatorButton
            /*if "C" == calculatorButton.text! {
                calculatorButtonsMap[CalculatorKey.fromValue(element: "<")!.rawValue] = calculatorButton
                let tapGestureForCalcButtonDel = UILongPressGestureRecognizer(target: self, action: #selector(switchCancelDelete))
                tapGestureForCalcButtonDel.minimumPressDuration = 1
                calculatorButton.addGestureRecognizer(tapGestureForCalcButtonDel)
            }*/

        }
        initAnimations()
        
        
        /*let calculatorLayer = CALayer()
        
        calculatorLayer.frame = CGRect(x: Double(calcDisplayLabel.frame.origin.x), y: Double(calcDisplayLabel.frame.origin.y), width: Double(calcDisplayLabel.frame.size.width - 2), height: Double(calcDisplayLabel.frame.size.height - 2))
        calculatorLayer.backgroundColor = UIColor.blue.cgColor
        calcDisplayLabel.layer.addSublayer(calculatorLayer)*/
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchCancelDelete(tapsender:UITapGestureRecognizer) {
        if tapsender.state != UIGestureRecognizerState.ended {
            return
        }
        if DataManager.dataManager.cancelOn {
            calculatorButtonsMap[CalculatorKey.fromValue(element: "C")!.rawValue]?.text! = "<"
            DataManager.dataManager.cancelOn = false
        } else {
            calculatorButtonsMap[CalculatorKey.fromValue(element: "<")!.rawValue]?.text! = "C"
            DataManager.dataManager.cancelOn = true
        }
    }

    func selectCalculatorButton(tapsender:UITapGestureRecognizer){
        
        let calcButton = tapsender.view as! UILabel
        debugPrint("Tapped \(calcButton.text!)")
        /*UIView.animate(withDuration: 0.1,
                       animations: {
                            calcButton.transform = CGAffineTransform(scaleX:0.9, y: 0.9)
                        },
                       completion: { finish in
                            UIView.animate(withDuration:0.05){
                                    calcButton.transform = CGAffineTransform.identity
                            }
            }
        )*/

        //calcButton.layer.add(buttonPressedAnimation, forKey: "press")

        let randomNum = arc4random_uniform(100)
        if(randomNum < 33) {
            calcButton.layer.add(buttonXRotationAnimation, forKey: "press")
        } else if(randomNum < 66) {
            calcButton.layer.add(buttonYRotationAnimation, forKey: "press")
        }else {
            calcButton.layer.add(buttonZRotationAnimation, forKey: "press")
        }
        
        
        DataManager.dataManager.manageInsertedData(calcButtonElement: calcButton.text!)
        /*switch calcButton.text {
            
        case CalculatorKey.C :
            println("tap gesture is working fine 1")
        case 2 :
            println("tap gesture is working fine 2")
        case 3 :
            println("tap gesture is working fine 3")
        case 4 :
            println("tap gesture is working fine 4")
        case 5 :
            println("tap gesture is working fine 5")
        case 6 :
            println("tap gesture is working fine 6")
        default :
            println("tap gesture can not find view")
        }*/
    }

}

