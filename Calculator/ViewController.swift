//
//  ViewController.swift
//  Calculator
//
//  Created by Enzo Garofalo on 09/11/16.
//  Copyright © 2016 Enzo Garofalo. All rights reserved.
//

import UIKit
import QuartzCore
import CoreMotion
import AVFoundation
import SpriteKit

import Firebase
import GoogleMobileAds

class ViewController: UIViewController {
    
    let kBannerAdUnitID = "ca-app-pub-7817618166160000/4438545607"
    @IBOutlet weak var banner: GADBannerView!
    
    @IBOutlet var calcDisplayLabel: UIVerticalAlignLabel!
    @IBOutlet var expressionLabel: UILabel!
    
    
    @IBOutlet var calculatorButtons: [UILabel]!
    
    var calculatorButtonsMap : [Int:UILabel] = [:]
    
    let buttonPressedAnimation = CAKeyframeAnimation(keyPath: "transform.scale")

    let buttonYRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
    
    let buttonXRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
    
    let buttonZRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    
    var motionManager : CMMotionManager?

    var speechSynthesizer = AVSpeechSynthesizer();
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        DataManager.dataManager.initVars()
    }
    
    func initButtonAnimation() {
        buttonXRotationAnimation.fromValue = 0.0
        buttonXRotationAnimation.toValue = Double.pi * 2
        buttonXRotationAnimation.repeatCount = 1
        buttonXRotationAnimation.duration = 0.3

        buttonYRotationAnimation.fromValue = 0.0
        buttonYRotationAnimation.toValue = Double.pi * 2
        buttonYRotationAnimation.repeatCount = 1
        buttonYRotationAnimation.duration = 0.3

        buttonZRotationAnimation.fromValue = 0.0
        buttonZRotationAnimation.toValue = Double.pi * 2
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
            calculatorButton.layer.borderColor =  #colorLiteral(red: 0.9835214979, green: 1, blue: 0.06484311418, alpha: 1).cgColor
            
            calculatorButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.03921568627, blue: 1, alpha: 1)
            
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
        loadAd()
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

        let utterance = AVSpeechUtterance(string: calcButton.text!)
        self.speechSynthesizer.speak(utterance)
        calcButton.layer.add(buttonPressedAnimation, forKey: "press")
        if calcButton.text=="=" {
            calcButton.layer.add(buttonPressedAnimation, forKey: "press")
        }
        debugPrint("Tapped \(calcButton.text!)")
        

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

    func loadAd() {
        
        
        banner.adUnitID = kBannerAdUnitID
        banner.rootViewController = self
        
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        banner.load(request)
        //banner.load(GADRequest())
    }
}

