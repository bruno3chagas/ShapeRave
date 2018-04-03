//
//  CircleFactory
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import SpriteKit

/// This class handles the creation of circles and their actions on scene.
public class CircleFactory {
    
    // MARK: - Properties
    
    /// This instance will be used to implement singleton in this class.
    private static var instance: CircleFactory = {
        let circleFactory = CircleFactory()
        return circleFactory
    }()
    
    /// All circles on scene
    public var circles: [Circle] = []
    
    /// All possible initial colors
    public var colors: [UIColor] = []
    
    /// Minimum and maximum circle possible initial sizes
    public let minSizeCircle: CGFloat = 15
    public let maxSizeCircle: CGFloat = 45
    
    // MARK: - Initialization
    private init() {
        let maxCircles = ChangableAttributes.shared().maxCircles
        
        colors.append(contentsOf: [
            UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1),
            UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1),
            UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1),
            UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1),
            UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1),
            UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1)])
        
        
        for index in 0..<maxCircles {
            let circle = Circle(radius: CGFloat.random(min: minSizeCircle, max: maxSizeCircle), color: UIColor.randomColor(colors), position: randomPosition())
            circle.name = "circle\(index)"
            circles.append(circle)
        }
        // This is applyied multiple times to get a better visual result
        for _ in 0..<circles.count/3 {
            separateCircles()
        }
        applyRotationMovement()
    }
    
    // MARK: - Class Methods
    open class func shared() -> CircleFactory {
        return instance
    }
    
    // MARK: - Object Methods
    
    /// Applies the perpetual rotation movement on all existent circles on scene.
    public func applyRotationMovement() {
        for circle in circles {
            circle.trajectory = SKShapeNode(ellipseIn: CGRect(x: circle.shape.position.x,
                                                              y: circle.shape.position.y,
                                                              width: 13,
                                                              height: 8))
            circle.trajectory.isHidden = true
            GlobalScene.shared().addChild(circle.trajectory)
            circle.trajectory.position = circle.shape.position
            circle.applyRotationMovement()
        }
    }
    
    /// Organize all existent circles on scene to be separeted from each other.
    public func separateCircles() {
        for (index1, circle1) in circles.enumerated() {
            for (index2, circle2) in circles.enumerated() {
                if index1 != index2 {
                    let dx = circle1.shape.position.x - circle2.shape.position.x
                    let dy = circle1.shape.position.y - circle2.shape.position.y
                    let distance = sqrt(dx*dx+dy*dy)
                    
                    if(distance < (circle1.shape.frame.width/2 + circle2.shape.frame.width/2 + 25)) {
                        let difference = (circle1.shape.frame.width/2 + circle2.shape.frame.width/2 + 25) - distance
                        let percent = difference/distance/2
                        let offsetx = dx*percent
                        let offsety = dy*percent
                        
                        circle1.shape.position.x += offsetx
                        circle1.shape.position.y += offsety
                        
                        circle2.shape.position.x -= offsetx
                        circle2.shape.position.y -= offsety
                        
                        circle1.shape.position = circle1.shape.position
                        circle2.shape.position = circle2.shape.position
                    }
                }
            }
        }
    }
    
    /// Gets a random position on the scene limits.
    public func randomPosition() -> CGPoint {
        let sceneSize = GlobalScene.shared().size
        let x = CGFloat.random(min: 0 + CGFloat(maxSizeCircle), max: sceneSize.width - CGFloat(maxSizeCircle))
        let y = CGFloat.random(min: 0 + CGFloat(maxSizeCircle), max: sceneSize.height - CGFloat(maxSizeCircle))
        return CGPoint(x: x, y: y)
    }
    
}
