//
//  StatisticsCollectionViewCell.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 04.08.24.
//

import UIKit

final class StatisticsCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "StatisticsCollectionViewCellIdentifier"
    
    private var icon: UIImageView!
    private var spinnerView: SpinnerView!
    private var container: UIView!
    private var gradientView: UIView!
    
    private let theme = StatisticsCollectionViewCellTheme()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupIconView()
        setupSpinnerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
    }
    
    private func setupContainerView() {
        container = UIView(frame: bounds)
        contentView.addSubview(container)
        container.clipsToBounds = true
        container.layer.cornerRadius = theme.cornerRadius
        container.backgroundColor = theme.backgroundColor
        BorderLayerMaker().addGradientBorder(view: container,
                          colors: theme.gradientColors,
                          width: theme.borderWidth)
    }
    
    private func setupIconView() {
        let aspectRatioSize = contentView.bounds.height - 2 * theme.verticalInset
        icon = UIImageView(frame: CGRect(x: theme.horizontalInset,
                                         y: theme.verticalInset,
                                                width: aspectRatioSize,
                                                height: aspectRatioSize))
        icon.contentMode = .scaleAspectFill
        contentView.addSubview(icon)
    }
    
    private func setupSpinnerView() {
        let height = contentView.bounds.height - 2 * theme.verticalInset
        let width = contentView.bounds.width - height - 2 * theme.horizontalInset
        spinnerView = SpinnerView(frame: CGRect(x: theme.horizontalInset + height,
                                                y: theme.verticalInset,
                                                width: width,
                                                height: height))
        contentView.addSubview(spinnerView)
    }
    
    func configure(typeIcon: UIImage?, number: Double, currencyIcon: UIImage?, fractionDigits: Int) {
        self.icon.image = typeIcon
        self.spinnerView.set(icon: currencyIcon)
        spinnerView.update(number: number, animated: false, fractionDigits: fractionDigits)
    }
    
    func updateSpinnerWithValue(_ value: Double?, fractionDigits: Int) {
        spinnerView.update(number: value, animated: true, fractionDigits: fractionDigits)
    }
    
}
