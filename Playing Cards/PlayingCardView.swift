//
//  PlayingCardView.swift
//  Playing Cards
//
//  Created by Mina Shoaib Rahman on 27/4/24.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat        = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat          = 0.06
        static let cornerOffsetToCornerRadius: CGFloat          = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat       = 0.60
        static let backCardImageSizeToBoundsSize: CGFloat       = 0.90
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
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
    
    private var imageScaleSize = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var rank = 10 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suit = "❤️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var faceUp = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var matched = false {
        didSet {
            self.isHidden = matched
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var controller: PlayingCardObserver?
    
    func setController(_ controller: PlayingCardObserver) {
        self.controller = controller
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    @objc func cardImageScalling(byPinch pinch: UIPinchGestureRecognizer) {
        switch pinch.state {
        case .changed, .ended:
            imageScaleSize *= pinch.scale
            pinch.scale = 1.0
        default: break
        }
    }
    
    private func centeredAttributedString(_ string: String, size: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(size)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, size: cornerFontSize)
    }
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !faceUp
    }
    
    private func drawPips() {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2, 1, 2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max ($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, size: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, size: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, size: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default: break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }

    override func draw(_ rect: CGRect) {
        let cardRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        cardRect.addClip()
        UIColor.white.setFill()
        cardRect.fill()
        if faceUp {
            if let faceCardImage = UIImage(named: rankString, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
//            if let faceCardImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: imageScaleSize))
            } else {
                drawPips()
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds.zoom(by: SizeRatio.backCardImageSizeToBoundsSize))
            }
        }
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

    @objc func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            UIView.transition(with: self, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
                self.faceUp = !self.faceUp
            }, completion: { completed in
                self.controller?.cardFlipped()
            })
        default:
            break
        }
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
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

protocol PlayingCardObserver {
    func cardFlipped()
}
