//
//  UIView+Helper.swift
//  Tmmim
//
//  Created by Jamil Bin Hossain on 3/5/21.
//

import UIKit

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var corner_Radius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var isCircle: Bool {
        set {
            let flag = newValue
            if flag {
                layer.cornerRadius = self.frame.size.width / 2
                self.clipsToBounds = true
            } else {
                layer.cornerRadius = 0
                clipsToBounds = false
            }
        }
        get {
            return clipsToBounds
        }
    }
    
    @IBInspectable var isRoundedCorner: Bool {
        set {
            let flag = newValue
            if flag {
                layer.cornerRadius = self.bounds.height / 2
                self.clipsToBounds = true
            } else {
                layer.cornerRadius = 0
                clipsToBounds = false
            }
        }
        get {
            return clipsToBounds
        }
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.fade))
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addBorderWithColor(borderWidth: Int = 1, color: UIColor = UIColor.red) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = color.cgColor
    }
    
    func adjustNavBackground(_ isClear: Bool) {
        if isClear == true {
            self.backgroundColor = UIColor.clear
        } else {
            //self.backgroundColor = UIColor.maMegenda
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
    
}

extension UIImage {
    
    /// Creates a circular outline image.
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
    return input.rawValue
}


extension UILabel {
    func setAsteriskRedColor() {
        guard let currentTxt = text else {return}
        //let attributedString = NSMutableAttributedString(string: currentTxt)
        //attributedString.setColorForText(textForAttribute: "*", withColor: .red, font: font)
        //attributedText = attributedString
    }
}
