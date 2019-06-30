//
//  Copyright © 2019 Zaid M. Said. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit

private enum Button: Int {
    case decrease
    case increase
}

@IBDesignable
class CustomStepper: UIControl, ViewControllerHelper {

    @IBInspectable
    var value: Double = 0.0 {
        didSet {
            if self.value > self.maximum || self.value < self.minimum {
                // discard
            } else if oldValue != self.value {
                sendActions(for: .valueChanged)
                setFormattedValue(self.value)
                setState()
            }
        }
    }

    @IBInspectable
    var minimum: Double = 0.0 {
        didSet {
            setState()
        }
    }

    @IBInspectable
    var maximum: Double = 100.0 {
        didSet {
            setState()
        }
    }

    @IBInspectable
    var step: Double = 1.0

    @IBInspectable
    var enableManualEditing: Bool = false {
        didSet {
            self.valueLabel.isUserInteractionEnabled = self.enableManualEditing
        }
    }

    @IBInspectable
    var autorepeat: Bool = true

    @IBInspectable
    var highlightedBackgroundColor: UIColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.13)

    @IBInspectable
    var disabledIconButtonColor: UIColor = UIColor(red: 127.0 / 255.0, green: 188.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)

    @IBInspectable
    var disabledBackgroundButtonColor: UIColor = UIColor.clear

    @IBInspectable
    var backgroundButtonColor: UIColor = UIColor.clear {
        didSet {
            self.decreaseButton.backgroundColor = self.backgroundButtonColor
            self.increaseButton.backgroundColor = self.backgroundButtonColor
        }
    }

    @IBInspectable
    var backgroundLabelColor: UIColor = UIColor.clear {
        didSet {
            self.valueLabel.backgroundColor = self.backgroundLabelColor
        }
    }

    @IBInspectable
    var labelTextColor: UIColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) {
        didSet {
            self.valueLabel.textColor = self.labelTextColor
        }
    }

    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }() {
        didSet {
            setFormattedValue(self.value)
        }
    }

    let defaultWidth = 141.0

    let defaultHeight = 29.0

    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    lazy var decreaseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.tag = Button.decrease.rawValue
        button.backgroundColor = self.backgroundButtonColor
        return button
    }()

    lazy var increaseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.backgroundColor = UIColor.clear
        button.tag = Button.increase.rawValue
        return button
    }()

    private var decreaseLayer = CAShapeLayer()

    private var increaseLayer = CAShapeLayer()

    private var leftSeparator = CAShapeLayer()

    private var rightSeparator = CAShapeLayer()

    private var continuousTimer: Timer? {
        didSet {
            if let timer = oldValue {
                timer.invalidate()
            }
        }
    }

    override init(frame: CGRect) {
        let frameWithDefaultSize = CGRect(x: Double(frame.origin.x), y: Double(frame.origin.y), width: self.defaultWidth, height: self.defaultHeight)
        super.init(frame: frameWithDefaultSize)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        addSubview(self.decreaseButton)
        addSubview(self.valueLabel)
        addSubview(self.increaseButton)

        // Control events
        self.decreaseButton.addTarget(self, action: #selector(decrease(_:)), for: [.touchUpInside, .touchCancel])
        self.increaseButton.addTarget(self, action: #selector(increase(_:)), for: [.touchUpInside, .touchCancel])
        self.increaseButton.addTarget(self, action: #selector(stopContinuous(_:)), for: .touchUpOutside)
        self.decreaseButton.addTarget(self, action: #selector(stopContinuous(_:)), for: .touchUpOutside)
        self.decreaseButton.addTarget(self, action: #selector(selected(_:)), for: .touchDown)
        self.increaseButton.addTarget(self, action: #selector(selected(_:)), for: .touchDown)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelPressed(_:)))
        self.valueLabel.addGestureRecognizer(tapGesture)
    }

    override func prepareForInterfaceBuilder() {
        setUp()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.defaultWidth, height: self.defaultHeight)
    }

    override static var requiresConstraintBasedLayout: Bool {
        return true
    }

    override func layoutSubviews() {
        let sliceWidth = bounds.width / 3
        let sliceHeight = bounds.height

        self.decreaseButton.frame = CGRect(x: 0, y: 0, width: sliceWidth, height: sliceHeight)
        self.valueLabel.frame = CGRect(x: sliceWidth, y: 0, width: sliceWidth, height: sliceHeight)
        self.increaseButton.frame = CGRect(x: sliceWidth * 2, y: 0, width: sliceWidth, height: sliceHeight)

        setFormattedValue(self.value)
    }

    override func draw(_ rect: CGRect) {
        let sliceWidth = bounds.width / 3
        let sliceHeight = bounds.height
        let thickness = 1.0 as CGFloat
        let iconSize: CGFloat = sliceHeight * 0.6

        self.valueLabel.backgroundColor = self.backgroundLabelColor
        self.valueLabel.textColor = self.labelTextColor

        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        backgroundColor = UIColor.clear
        clipsToBounds = true

        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: sliceWidth, y: 0.0))
        leftPath.addLine(to: CGPoint(x: sliceWidth, y: sliceHeight))
        tintColor.setStroke()
        leftPath.stroke()

        self.leftSeparator.path = leftPath.cgPath
        self.leftSeparator.strokeColor = tintColor.cgColor
        layer.addSublayer(self.leftSeparator)

        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(x: sliceWidth * 2, y: 0.0))
        rightPath.addLine(to: CGPoint(x: sliceWidth * 2, y: sliceHeight))
        tintColor.setStroke()
        rightPath.stroke()

        self.rightSeparator.path = rightPath.cgPath
        self.rightSeparator.strokeColor = tintColor.cgColor
        layer.addSublayer(self.rightSeparator)

        let decreasePath = UIBezierPath()
        decreasePath.lineWidth = thickness
        decreasePath.move(to: CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5, y: sliceHeight / 2 + 0.5))
        decreasePath.addLine(to: CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5 + iconSize, y: sliceHeight / 2 + 0.5))
        tintColor.setStroke()
        decreasePath.stroke()

        self.decreaseLayer.path = decreasePath.cgPath
        self.decreaseLayer.strokeColor = tintColor.cgColor
        layer.addSublayer(self.decreaseLayer)

        let increasePath = UIBezierPath()
        increasePath.lineWidth = thickness
        increasePath.move(to: CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5 + sliceWidth * 2, y: sliceHeight / 2 + 0.5))
        increasePath.addLine(to: CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5 + iconSize + sliceWidth * 2, y: sliceHeight / 2 + 0.5))
        increasePath.move(to: CGPoint(x: sliceWidth / 2 + 0.5 + sliceWidth * 2, y: (sliceHeight / 2) - (iconSize / 2) + 0.5))
        increasePath.addLine(to: CGPoint(x: sliceWidth / 2 + 0.5 + sliceWidth * 2, y: (sliceHeight / 2) + (iconSize / 2) + 0.5))
        tintColor.setStroke()
        increasePath.stroke()

        self.increaseLayer.path = increasePath.cgPath
        self.increaseLayer.strokeColor = tintColor.cgColor
        layer.addSublayer(self.increaseLayer)

        setState()
    }

    // MARK: Control Events

    @objc func decrease(_ sender: UIButton) {
        self.continuousTimer = nil
        decreaseValue()
    }

    @objc func increase(_ sender: UIButton) {
        self.continuousTimer = nil
        increaseValue()
    }

    @objc func continuousIncrement(_ timer: Timer) {
        let userInfo = timer.userInfo as! Dictionary<String, AnyObject>
        guard let sender = userInfo["sender"] as? UIButton else { return }

        if sender.tag == Button.decrease.rawValue {
            decreaseValue()
        } else {
            increaseValue()
        }
    }

    @objc func selected(_ sender: UIButton) {
        if self.autorepeat {
            self.continuousTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(continuousIncrement), userInfo: ["sender" : sender], repeats: true)
        }
        sender.backgroundColor = self.highlightedBackgroundColor
    }

    @objc func stopContinuous(_ sender: UIButton) {
        self.continuousTimer = nil
    }

    func increaseValue() {
        let roundedValue = value.rounded(toPlaces: self.numberFormatter.maximumFractionDigits)
        if roundedValue + self.step <= self.maximum && roundedValue + self.step >= self.minimum {
            self.value = roundedValue + self.step
        }
    }

    func decreaseValue() {
        let roundedValue = self.value.rounded(toPlaces: self.numberFormatter.maximumFractionDigits)
        if roundedValue - self.step <= self.maximum && roundedValue - self.step >= self.minimum {
            self.value = roundedValue - self.step
        }
    }

    @objc func labelPressed(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Enter Value", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Value"
            textField.keyboardType = .decimalPad
        }
        let action1 = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let newString = alertController.textFields?.first?.text, let newValue = Double(newString) {
                if newValue >= self.minimum || newValue <= self.maximum {
                    self.value = newValue
                }
            }
        }
        alertController.addAction(action1)
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action2)
        topMostViewController?.present(alertController, animated: true, completion: nil)
    }

    private func setState() {
        if self.value >= self.maximum {
            self.increaseButton.isEnabled = false
            self.increaseButton.backgroundColor = self.disabledBackgroundButtonColor
            self.increaseLayer.strokeColor = self.disabledIconButtonColor.cgColor
            self.decreaseButton.isEnabled = true
            if self.continuousTimer == nil {
                self.decreaseButton.backgroundColor = self.backgroundButtonColor
            }
            self.continuousTimer = nil
        } else if self.value <= self.minimum {
            self.increaseButton.isEnabled = true
            if self.continuousTimer == nil {
                self.increaseButton.backgroundColor = self.backgroundButtonColor
            }
            self.decreaseButton.isEnabled = false
            self.decreaseButton.backgroundColor = self.disabledBackgroundButtonColor
            self.decreaseLayer.strokeColor = self.disabledIconButtonColor.cgColor
            self.continuousTimer = nil
        } else {
            self.increaseButton.isEnabled = true
            self.increaseButton.backgroundColor = self.backgroundButtonColor
            self.increaseLayer.strokeColor = tintColor.cgColor
            self.decreaseButton.isEnabled = true
            self.decreaseButton.backgroundColor = self.backgroundButtonColor
            self.decreaseLayer.strokeColor = tintColor.cgColor
        }
    }

    private func setFormattedValue(_ value: Double) {
        self.valueLabel.text = self.numberFormatter.string(from: NSNumber(value: value))
    }

    override func tintColorDidChange() {
        layer.borderColor = tintColor.cgColor
        self.valueLabel.textColor = self.labelTextColor
        self.leftSeparator.strokeColor = tintColor.cgColor
        self.rightSeparator.strokeColor = tintColor.cgColor
        self.increaseLayer.strokeColor = tintColor.cgColor
        self.decreaseLayer.strokeColor = tintColor.cgColor
    }
}
