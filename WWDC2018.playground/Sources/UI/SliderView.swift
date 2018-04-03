//
//  SliderView
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import UIKit

/// Personalized view containing a UISlider.
public class SliderView: UIView {
    
    // MARK: - Attribures
    
    public var valueLabel: UILabel
    public var slider: UISlider
    public var nameLabel: UILabel
    
    /// The attribute the slider will affect
    public var type: Attribute
    
    /// The format name label should present a number
    public var format: String = ""
    
    /// The words used as values
    public var words: [String] = []
    
    /// Indicates if a number should be present as an int or not
    public var isRoundNumber: Bool = false
    
    // MARK: - Initialization
    
    init(frame: CGRect, minimumValue: Float, maximumValue: Float, value: Float, name: String, type: Attribute, format: String, isRoundNumber: Bool? = false) {
        
        self.type = type
        self.format = format
        self.isRoundNumber = isRoundNumber ?? false
        
        // Name Label
        self.nameLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 165, height: 18))
        self.nameLabel.text = name
        self.nameLabel.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.nameLabel.textAlignment = .center
        self.nameLabel.font = UIFont.systemFont(ofSize: 16)
        self.nameLabel.adjustsFontSizeToFitWidth = true
        
        // Slider
        self.slider = UISlider(frame: CGRect(x: 15, y: 20, width: 165, height: 30))
        self.slider.minimumValue = minimumValue
        self.slider.maximumValue = maximumValue
        let thumbImage = UIImage(named: "Thumb")!.withRenderingMode(.alwaysOriginal)
        self.slider.setThumbImage(thumbImage, for: .normal)
        self.slider.setThumbImage(thumbImage, for: .highlighted)
        self.slider.isContinuous = true
        self.slider.maximumTrackTintColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        self.slider.tintColor = UIColor.white
        self.slider.value = value
        self.slider.contentHorizontalAlignment = .center
        
        // Value Label
        self.valueLabel = UILabel(frame: CGRect(x: 15, y: 45, width: 165, height: 18))
        self.valueLabel.text = String(format: format, value)
        self.valueLabel.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.valueLabel.textAlignment = .center
        self.valueLabel.font = UIFont.systemFont(ofSize: 14)
        self.valueLabel.adjustsFontSizeToFitWidth = true
        
        super.init(frame: frame)
        
        self.slider.addTarget(self, action: #selector(valueNumberChanged), for: .valueChanged)
        self.addSubview(self.valueLabel)
        self.addSubview(self.slider)
        self.addSubview(self.nameLabel)

    }
    
    init(frame: CGRect, words: [String], name: String, positionValue: Int, type: Attribute) {
        
        self.type = type
        self.words = words
        
        // Name Label
        self.nameLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 165, height: 18))
        self.nameLabel.text = name
        self.nameLabel.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.nameLabel.textAlignment = .center
        self.nameLabel.font = UIFont.systemFont(ofSize: 16)
        self.nameLabel.adjustsFontSizeToFitWidth = true
        
        // Slider
        self.slider = UISlider(frame: CGRect(x: 15, y: 20, width: 165, height: 30))
        self.slider.minimumValue = 0
        self.slider.maximumValue = Float(words.count - 1)
        let thumbImage = UIImage(named: "Thumb")!
        self.slider.setThumbImage(thumbImage, for: .normal)
        self.slider.setThumbImage(thumbImage, for: .highlighted)
        self.slider.isContinuous = true
                self.slider.maximumTrackTintColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        self.slider.tintColor = UIColor.white
        self.slider.value = Float(positionValue)
        self.slider.contentHorizontalAlignment = .center
        
        // Value Label
        self.valueLabel = UILabel(frame: CGRect(x: 15, y: 45, width: 165, height: 18))
        self.valueLabel.text = String(describing: words[positionValue])
        self.valueLabel.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.valueLabel.textAlignment = .center
        self.valueLabel.font = UIFont.systemFont(ofSize: 14)
        self.valueLabel.adjustsFontSizeToFitWidth = true
        
        super.init(frame: frame)
        
        self.slider.addTarget(self, action: #selector(valueStringChanged), for: .valueChanged)
        self.addSubview(self.valueLabel)
        self.addSubview(self.slider)
        self.addSubview(self.nameLabel)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Object Methods
    
    /// Executes a routine when a slider for string values is changed
    @objc func valueStringChanged(_ sender: UISlider) {
        sender.value.round()
        self.valueLabel.text = String(describing: self.words[Int(sender.value)])
        ChangableAttributes.shared().updateAttribute(self.type, value: sender.value)
    }
    
    /// Executes a routine when a slider for number values is changed
    @objc func valueNumberChanged(_ sender: UISlider) {
        if isRoundNumber {
            sender.value.round()
        }
        self.valueLabel.text = String(format: self.format, sender.value)
        ChangableAttributes.shared().updateAttribute(self.type, value: sender.value)
    }
    
}
