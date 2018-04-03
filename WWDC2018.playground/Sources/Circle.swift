//
//  Circle
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import SpriteKit

/// Class responsable for treating a circle object.
public class Circle: SKNode, RotationProtocol, KnockbackProtocol {
    
    // MARK: - Attributes
    
    /// The initial circle's radius
    public var radius: CGFloat
    
    /// The initial circle's color
    public var color: UIColor
    
    /// The shape of the circle
    public var shape: SKShapeNode
    
    /// The mask is a SKShapeNode with the same size of the shape, it is used as a layer to blend with the color of the shape attribute
    public var mask: SKShapeNode
    
    // MARK: - Knockback Protocol Attributes
    
    /// This marks the position the circle is before it is knocked back
    public var positionBeforeAction: CGPoint = CGPoint.zero
    
    /// When the user is holding the touch on a circle, it keeps creating knockback actions on the other circles. This attibute is the count for those actions.
    public var currentActionStackNumber: Int = 0
    
    /// This timer will help track when it's time to return everything back to normal
    public var timer: Timer? = nil
    
    // MARK: - Rotation Protocol Attributes
    
    /// The time it takes to complete a rotation cicle
    public var cicleTime: TimeInterval
    
    /// The trajectory's shape a circle has to go through
    public var trajectory: SKShapeNode
    
    /// If the movement is clockwise or countclockwise
    public var direction: Direction
    
    // MARK: - Initialization
    
    public init(radius: CGFloat, color: UIColor, position: CGPoint) {
        
        self.radius = radius
        
        self.shape = SKShapeNode(circleOfRadius: radius)
        self.mask = SKShapeNode(circleOfRadius: radius)
        
        let alpha = CGFloat.random(min: 0.6, max: 0.9)
        self.color = color.withAlphaComponent(alpha)
        self.shape.fillColor = self.color
        self.shape.strokeColor = self.color
        self.shape.position = position
        GlobalScene.shared().addChild(self.shape)
        
        self.mask.fillColor = .clear
        self.mask.strokeColor = .clear
        self.mask.blendMode = ChangableAttributes.shared().blendMode
        
        self.cicleTime = TimeInterval(CGFloat.random(min: 3, max: 5))
        self.trajectory = SKShapeNode()
        self.direction = arc4random_uniform(2) == 1 ? .clockwise : . counterclockwise
        
        super.init()
        
        self.shape.addChild(self.mask)
        self.mask.isUserInteractionEnabled = false
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Protocol Methods
    
    /// Handles what is necessary to apply a perpetual rotation movement on a circle.
    public func applyRotationMovement() {
        let follow: SKAction
        
        if direction == .clockwise {
            follow = SKAction.follow((self.trajectory.path)!, asOffset: false, orientToPath: true, duration: cicleTime).reversed()
        }
        else {
            follow = SKAction.follow((self.trajectory.path)!, asOffset: false, orientToPath: true, duration: cicleTime)
        }
        
        let repeatForever = SKAction.repeatForever(follow)
        self.shape.run(repeatForever, withKey: "rotationAction")
        self.shape.action(forKey: "rotationAction")!.speed = ChangableAttributes.shared().rotationSpeed
        
    }
    
    /// This method calculates the distance between the interacted circle and other and then normalize it based on the setted knockback distance.
    public func normalizeDistance(circle: Circle) -> CGVector {
        let dx = self.shape.position.x - circle.shape.position.x
        let dy = self.shape.position.y - circle.shape.position.y
        let distance = sqrt(dx*dx+dy*dy)
        let xNormalized = dx * ChangableAttributes.shared().knockbackDistance / distance
        let yNormalized = dy * ChangableAttributes.shared().knockbackDistance / distance
        return CGVector(dx: xNormalized, dy: yNormalized)
    }
    
    
    /// Creates a knockback action movement that also makes the circle go back to normal.
    public func createKnockbackAction(circle: Circle) -> SKAction{
        let vector = normalizeDistance(circle: circle)
        let moveForward = SKAction.move(to: CGPoint(x: circle.shape.position.x - vector.dx, y: circle.shape.position.y - vector.dy), duration: ChangableAttributes.shared().knockbackTime)
        let moveBack = SKAction.move(to: CGPoint(x: circle.positionBeforeAction.x, y: circle.positionBeforeAction.y), duration: ChangableAttributes.shared().knockbackTime)
        return SKAction.sequence([moveForward, moveBack])
    }
    
    /// Handles what is necessary to apply a knockback effect on a circle.
    public func applyKnockbackMovement(circle: Circle) {
        let vector = normalizeDistance(circle: circle)

        guard let action = circle.shape.action(forKey: "rotationAction") else {
            return
        }
        action.speed = 0
        
        
        if (!vector.dx.isNaN || !vector.dy.isNaN) {
            if circle.positionBeforeAction == CGPoint.zero {
                circle.positionBeforeAction = circle.shape.position
            }

            let sequence = self.createKnockbackAction(circle: circle)
            circle.currentActionStackNumber += 1
            circle.shape.run(sequence, withKey: "knockbackAction\(circle.currentActionStackNumber)")
        }
        
        if circle.timer != nil {
            circle.timer!.invalidate()
            circle.timer = nil
        }
        
        circle.timer = Timer.scheduledTimer(withTimeInterval: ChangableAttributes.shared().knockbackTime * 2, repeats: false) { (timer) in
            action.speed = ChangableAttributes.shared().rotationSpeed
            circle.positionBeforeAction = CGPoint.zero
            
            // Kills every knockback action stacked and unused
            for index in stride(from: circle.currentActionStackNumber, to: 1, by: -1) {
                if circle.shape.action(forKey: "knockbackAction\(index)") != nil {
                    circle.shape.removeAction(forKey: "knockbackAction\(index)")
                }
            }
            circle.currentActionStackNumber = 0
            
        }
    }
    
    /// Applies an effect of rescale. The circle will transform to a size and then return to normal according with knockback time.
    public func rescale(circle: Circle) {
        let scaleUp = SKAction.scale(to: ChangableAttributes.shared().resizeVariation, duration: ChangableAttributes.shared().knockbackTime)
        let scaleDown = SKAction.scale(to: 1, duration: ChangableAttributes.shared().knockbackTime)
        
        let sequence = SKAction.sequence([scaleUp, scaleDown])

        circle.shape.run(sequence)
    }
    
    /// This method handles the propagation of actions the circles should recieve when occurs an interaction.
    public func propagateActions() {
        let circles = CircleFactory.shared().circles
        let organizedCircles = sortByDistance(array: circles)
        var count = 0
                
        Timer.scheduledTimer(withTimeInterval: 0.0001, repeats: true) { (timer) in
            
            if (count < organizedCircles.count) {
                
                repeat {
                    self.rescale(circle: organizedCircles[count])
                    
                    self.applyKnockbackMovement(circle: organizedCircles[count])
                    organizedCircles[count].mask.fillColor = self.shape.fillColor
                    organizedCircles[count].mask.strokeColor = self.shape.strokeColor
                    count += 1
                } while (count % ChangableAttributes.shared().propagationQuantity != 0 && count <= organizedCircles.count - 1)
                
            }
            else {
                timer.invalidate()
            }
        }
    }
    
    /// Sorts an array of circles.
    private func sortByDistance(array: [Circle]) -> [Circle] {
        
        let organizedArray = array.sorted(by: {
            let dx1 = self.shape.position.x - $0.shape.position.x
            let dy1 = self.shape.position.y - $0.shape.position.y
            let distance1 = sqrt(dx1*dx1+dy1*dy1)
            
            let dx2 = self.shape.position.x - $1.shape.position.x
            let dy2 = self.shape.position.y - $1.shape.position.y
            let distance2 = sqrt(dx2*dx2+dy2*dy2)
            
            return distance1 < distance2
        })
        
        return organizedArray
    }
}
