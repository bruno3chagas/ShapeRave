//
//  KnockbackProtocol
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import SpriteKit

/// Objects that suffer knockback should implement this protocol.
public protocol KnockbackProtocol {
    var positionBeforeAction: CGPoint { get set }
    var currentActionStackNumber: Int { get set }
    var timer: Timer? { get set }
    
    func normalizeDistance(circle: Circle) -> CGVector
    func createKnockbackAction(circle: Circle) -> SKAction
}
