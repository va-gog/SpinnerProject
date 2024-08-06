//
//  BorderLayerMaker.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/5/24.
//

import UIKit

struct BorderLayerMaker {
    func addGradientBorder(view: UIView, colors: [UIColor], width: CGFloat)  {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
        
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: view.bounds.insetBy(dx: width / 2, dy: width / 2), cornerRadius: view.layer.cornerRadius)
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = width
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        view.layer.addSublayer(gradientLayer)
    }
}
