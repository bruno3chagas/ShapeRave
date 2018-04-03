//
//  RotationProtocol
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import SpriteKit

/// Objects that rotate should implement this protocol.
public protocol RotationProtocol {
    var cicleTime: TimeInterval { get set }
    var trajectory: SKShapeNode { get set }
    var direction: Direction { get set }
    
    func applyRotationMovement()
}

public enum Direction {
    case clockwise
    case counterclockwise
}



