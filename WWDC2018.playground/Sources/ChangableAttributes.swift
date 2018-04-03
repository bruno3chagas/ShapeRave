//
//  ChangableAttributes
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import SpriteKit

/// This class is responsable for maintaining attributes that can be changed on the menu scene.
public class ChangableAttributes {
    
    // MARK: - Attributes
    
    /// This instance will be used to implement singleton in this class.
    private static var instance: ChangableAttributes = {
        return ChangableAttributes()
    }()
    
    /// With this attibute is possible to control how many circles will be rendered on scene.
    private var _maxCircles: Int = 60
    public var maxCircles: Int {
        get { return _maxCircles }
        set (value) {
            if value > 60 { _maxCircles = 60 }
            else if value < 1 { _maxCircles = 1 }
            else { _maxCircles = value }
        }
    }
    
    /// This property will influentiate on the wave effect, it indicates the amount of circles will recieve interaction per time.
    private var _propagationQuantity: Int = 5
    public var propagationQuantity: Int {
        get { return _propagationQuantity }
        set (value) {
            if value > _maxCircles { _propagationQuantity = _maxCircles }
            else if value < 1 { _propagationQuantity = 1 }
            else { _propagationQuantity = value }
        }
    }
    
    /// The circles have a perpetual eliptical movement, this property changes the velocity of this movement.
    private var _rotationSpeed: CGFloat = 1
    public var rotationSpeed: CGFloat {
        get { return _rotationSpeed }
        set (value) {
            if value > 10 { _rotationSpeed = 10 }
            else if value < 0 { _rotationSpeed = 0 }
            else { _rotationSpeed = value }
        }
    }
    
    /// This is the distance the circles are pushed when one is touched.
    private var _knockbackDistance: CGFloat = 20
    public var knockbackDistance: CGFloat {
        get { return _knockbackDistance }
        set (value) {
            if value > 60 { _knockbackDistance = 60 }
            else if value < 0 { _knockbackDistance = 0 }
            else { _knockbackDistance = value }
        }
    }
    
    /// This is the time it takes for the circles to finish the knockback action when one is touched.
    private var _knockbackTime: Double = 0.3
    public var knockbackTime: Double {
        get { return _knockbackTime }
        set (value) {
            if value > 3 { _knockbackTime = 3 }
            else if value < 0 { _knockbackTime = 0 }
            else { _knockbackTime = value }
        }
    }
    
    /// This changes the blending mode.
    private var _blendMode: SKBlendMode = .screen
    public var blendMode: SKBlendMode {
        get { return _blendMode }
        set (value) {
            _blendMode = value
        }
    }
    
    /// When the circles suffer knockback, they also receive a resize. The smaller the number, the smaller circles will be when happens an interaction.
    private var _resizeVariation: CGFloat = 1.1
    public var resizeVariation: CGFloat {
        get { return _resizeVariation }
        set (value) {
            if value > 1.5 { _resizeVariation = 1.5 }
            else if value < 0 { _resizeVariation = 0 }
            else { _resizeVariation = value }
        }
    }
    
    // MARK: - Object Methods
    
    /// This method is responsable for applying changes to attributes when a value is changed on menu.
    public func updateAttribute(_ attribute: Attribute, value: Float) {
        switch attribute {
        case .propagationQuantity:
            self.propagationQuantity = Int(value)
            
        case .rotationSpeed:
            self.rotationSpeed = CGFloat(value)
            self.changeCirclesRotationSpeed()
            
        case .knockbackDistance:
            self.knockbackDistance = CGFloat(value)
            
        case .knockbackTime:
            self.knockbackTime = Double(value)
            
        case .resizeVariation:
            self.resizeVariation = CGFloat(value)
            
        case .blendMode:
            self.changeCirclesBlendMode(value: value)
            
        }
    }
    
    public func changeCirclesRotationSpeed() {
        for circle in CircleFactory.shared().circles {
            circle.shape.action(forKey: "rotationAction")!.speed = ChangableAttributes.shared().rotationSpeed
        }
    }
    
    public func changeCirclesBlendMode(value: Float) {
        for circle in CircleFactory.shared().circles {
            circle.mask.blendMode = SKBlendMode(rawValue: Int(value))!
        }
    }
    
    // MARK: - Class Methods
    open class func shared() -> ChangableAttributes {
        return instance
    }
    
}

/// This enum is used to have a better control on the changeble attributes.
public enum Attribute: String {
    case propagationQuantity
    case rotationSpeed
    case knockbackDistance
    case knockbackTime
    case resizeVariation
    case blendMode
    
}
