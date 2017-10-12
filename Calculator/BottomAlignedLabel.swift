//
//  BottomAlignedLabel.swift
//  Calculator
//
//  Created by Crescenzo Garofalo on 12/10/17.
//  Copyright © 2017 Enzo Garofalo. All rights reserved.
//

import UIKit

@IBDesignable class BottomAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSFontAttributeName: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: rect.size.height - labelStringSize.height, width: self.frame.width, height: ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
 }

}
