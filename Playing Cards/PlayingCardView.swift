//
//  PlayingCardView.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 27/4/24.
//

import UIKit

class PlayingCardView: UIView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat =     0.085
        static let cornerRadiusToBoundsHeight: CGFloat =       0.06
        static let cornerOffsetToCornerRadius: CGFloat =       0.33
        static let faceCardImageSizeToBoundsSize: CGFloat =    0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String {
        switch rank {
        case 1: return "1"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
    
    private(set) var rank: Int = 10 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private(set) var suit: String = "❤️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private(set) var faceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func centeredAttributedString(_ string: String, size: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(size)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle])
    }
    
    private func cornerString() -> NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, size: cornerFontSize)
    }
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString()
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !faceUp
    }

    override func draw(_ rect: CGRect) {
        let cardRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        cardRect.addClip()
        UIColor.white.setFill()
        cardRect.fill()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
//            .translatedBy(x: lowerRightCornerLabel.frame.width, y: lowerRightCornerLabel.frame.height)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.width, dy: -lowerRightCornerLabel.frame.height)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }

}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width / 2, height: height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width / 2, height: height)
    }
}
