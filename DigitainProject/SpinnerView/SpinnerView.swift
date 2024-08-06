//
//  SpinnerView.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/4/24.
//

import UIKit

class SpinnerView: UIView {
    private let currencyImageView = UIImageView()
    private var containerView = UIView()

    private var prevNumber: Double?
    private var currentNumber: Double?
    
    private let theme = SpinnerViewTheme()
    private var offset = 0.0
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func update(number: Double?, animated: Bool, fractionDigits: Int) {
        guard let number, number != self.currentNumber else { return }
        self.prevNumber = self.currentNumber
        self.currentNumber = number
        self.layoutViews(value: number, animated: animated, fractionDigits: fractionDigits)
    }
    
    func set(icon: UIImage? = nil) {
        guard let icon else { return }
        self.currencyImageView.image = icon
    }
    
    private func setupView() {
        currencyImageView.tintColor = .lightGray
        addSubview(containerView)
        containerView.addSubview(currencyImageView)
        update(number: nil, animated: false, fractionDigits: 2)
    }
    
    private func layoutViews(value: Double?, animated: Bool, fractionDigits: Int) {
        let formattedNumber = ValueToStringFormatter().formatNumber(value ?? 0, fractionDigits: fractionDigits)
        
        let containerWidth = calculateTotalWidth(number: formattedNumber)
        offset = containerWidth
        
        layoutCurrencyIcon()
        
        let prevMaxTag = containerView.subviews.count - 1
        var tag = 1
        for char in formattedNumber.reversed() {
            if char == " " {
                offset -= theme.labelMaxWidth * theme.spaceWidthCoof
                continue
            }
           
            let label = createLabel(tag: tag)
            tag += 1
            
            if char == "." || char == "," {
                label.text = String(".")
                offset -= theme.labelMaxWidth * theme.pointLabelCoof
                label.frame = CGRect(x: offset,
                                      y: 0,
                                      width: theme.labelMaxWidth * theme.pointLabelCoof,
                                      height: bounds.height)
            } else {
               change(text: char, label: label, animated: animated)
                offset -= theme.labelMaxWidth
                label.frame = CGRect(x: offset,
                                      y: 0,
                                      width: theme.labelMaxWidth,
                                      height: bounds.height)
                
            }
        }
        
        removeLabelsIfNeeded(prevMaxTag: prevMaxTag, currentMaxTag: tag)
        containerView.frame = CGRect(x: (bounds.width - containerWidth) / 2,
                                     y: 0, 
                                     width: containerWidth,
                                     height: bounds.height)
        scaleContainerIfNeeded(containerWidth: containerWidth)

    }
    
    private func createLabel(tag: Int) -> UILabel  {
        var label: UILabel? = containerView.viewWithTag(tag) as? UILabel
        if label == nil {
            let newLabel = UILabel()
            newLabel.font = UIFont.systemFont(ofSize: theme.fontSize)
            newLabel.textAlignment = .center
            newLabel.textColor = theme.valueColor
            containerView.addSubview(newLabel)
            label = newLabel
        }
        label?.tag = tag
        return label!
    }
    
    private func layoutCurrencyIcon() {
        if currencyImageView.image != nil {
            let aspectRatioSize = theme.labelMaxWidth * theme.currencyWidthCoof
            offset -= aspectRatioSize
            currencyImageView.frame = CGRect(x: offset,
                                             y: (bounds.height - theme.curuencyIconBottomInset - aspectRatioSize),
                                             width: aspectRatioSize,
                                             height: aspectRatioSize)
        }
    }
    
    private func removeLabelsIfNeeded(prevMaxTag: Int, currentMaxTag: Int) {
        var prevMaxTag = prevMaxTag
        if prevMaxTag > currentMaxTag - 1 {
            while prevMaxTag != currentMaxTag - 1 {
                containerView.viewWithTag(prevMaxTag)?.removeFromSuperview()
                prevMaxTag -= 1
            }
        }
    }
    
    private func change(text: Character, label: UILabel, animated: Bool) {
        let newValue = Double(String(text)) ?? 0
        let oldValue = Double(label.text ?? "0") ?? 0
        let duration = 0.6 / 10
        let subtype: CATransitionSubtype = oldValue <= newValue ? .fromTop : .fromBottom
        
        if animated {
            animateLabelChange(label: label,
                               oldText: Int(oldValue),
                               newText: Int(newValue),
                               duration: duration,
                               subtype: subtype)
        } else {
            label.text = String(Int(newValue))
        }

    }
    
    private func scaleContainerIfNeeded(containerWidth: Double) {
        if containerWidth > bounds.width {
            containerView.transform = CGAffineTransform(scaleX: bounds.width / containerWidth,
                                                        y: 1)
        }
    }
    
    private func animateLabelChange(label: UILabel?,
                                    oldText: Int,
                                    newText: Int,
                                    duration: Double,
                                    subtype: CATransitionSubtype) {
        guard let label, oldText != newText else { return }
        let diff: Int = newText > oldText ? 1 : -1
        let updatedText = oldText + diff
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.animateLabelChange(label: label, oldText: updatedText, newText: newText, duration: duration, subtype: subtype)
        }
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .push
        animation.subtype = subtype
        animation.duration = duration
        
        label.layer.add(animation, forKey: "kCATransition")
        
        label.text = String(updatedText)
        
        CATransaction.commit()
    }
    
    private func calculateTotalWidth(number: String) -> Double {
        let labelWidth: CGFloat = theme.labelMaxWidth
        let pointWidth = theme.pointLabelCoof
        let currencyWidth = labelWidth * theme.currencyWidthCoof
        let spaceWidth = labelWidth * theme.spaceWidthCoof

        var totalWidth: CGFloat = 0.0
        for char in number {
            if char == "." || char == "," {
                totalWidth += pointWidth
            } else if char == " " {
                totalWidth += spaceWidth
            } else {
                totalWidth += labelWidth
            }
        }
        totalWidth += (currencyImageView.image == nil ? 0 : currencyWidth)
        return totalWidth
    }
}
